From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Wed, 25 May 2005 21:05:51 -0400
Message-ID: <429520EF.2070501@pobox.com>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <20050524075953.GY9855@suse.de> <4292E3EE.10006@pobox.com> <20050524085133.GZ9855@suse.de> <42935852.2020300@pobox.com> <20050525092952.GA7005@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080304080801070200040800"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20050525092952.GA7005@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080304080801070200040800
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
> On Tue, May 24 2005, Jeff Garzik wrote:
> 
>>Jens Axboe wrote:
>>
>>>I agree, it's a cleaner approach, with the rq being a container for
>>>generel messages as well not just SCSI commands. The one missing piece
>>>for that was the rq->end_io() callback so everything doesn't have to go
>>>down sync, but that is in now as well.
>>>
>>>I'll try and cook something up.
>>
>>Very cool ;)
> 
> 
> This is the base for it. It splits request->flags into two variables:
> 
> - cmd_type. this is not a bitmask, but a value indicating what type of
>   request this is.
> 
> - cmd_flags. various command modified flags.
> 
> The idea is to add a REQ_TYPE_LINUX_BLOCK request type, where we define
> a set of command opcodes that signify an upper level defined function
> (such as flush) that is implemented differently at the hardware/driver
> level. Basically a way to pass down messages or commands generically.
> 
> I like this better than using scsi opcodes always, it's a cleaner
> abstraction. For sending generic commands to a device, we could add a
> function ala:

cmd_type just adds a needless layer of switch{} statements in block 
drivers, and its information that can be trivially derived from the 
command opcode itself.

	cmd_type = cmd_types[opcode];

HOWEVER, don't fall in love with SCSI opcodes.

We want _Linux_ commands, not SCSI commands.  Just think of a 
request_queue as having its own command protocol, one that you can 
_change at will_.

Yes, often request_queue commands may map seamlessly to SCSI (or ATA or 
I2O) commands.  And that's good.  But don't let yourself be locked into 
SCSI.  SCSI is not generic enough, nor mutable enough for all our needs.

Just the other day I was thinking about the simpler approach, like the 
attached :)  It
* adds RQ_ to avoid namespace conflicts
* adds RQ_FLUSH, RQ_PM_EVENT

So, overall, I would say "think Linux opcodes" as the preferred direction.

	Jeff



--------------080304080801070200040800
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/include/linux/fs.h b/include/linux/fs.h
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -66,13 +66,24 @@ extern int dir_notify_enable;
 
 #define RW_MASK		1
 #define RWA_MASK	2
-#define READ 0
-#define WRITE 1
-#define READA 2		/* read-ahead  - don't block if no resources */
-#define SPECIAL 4	/* For non-blockdevice requests in request queue */
-#define READ_SYNC	(READ | (1 << BIO_RW_SYNC))
-#define WRITE_SYNC	(WRITE | (1 << BIO_RW_SYNC))
-#define WRITE_BARRIER	((1 << BIO_RW) | (1 << BIO_RW_BARRIER))
+#define RQ_READ		0
+#define RQ_WRITE	1
+#define RQ_READA	2	/* read-ahead  - don't block if no resources */
+#define RQ_SPECIAL	4	/* For non-blockdevice requests in request queue */
+#define RQ_READ_SYNC		(READ | (1 << BIO_RW_SYNC))
+#define RQ_WRITE_SYNC		(WRITE | (1 << BIO_RW_SYNC))
+#define RQ_WRITE_BARRIER	((1 << BIO_RW) | (1 << BIO_RW_BARRIER))
+#define RQ_FLUSH	7
+#define RQ_PM_EVENT	8
+
+/* compatibility with existing code */
+#define READ		RQ_READ
+#define WRITE		RQ_WRITE
+#define READA		RQ_READA
+#define SPECIAL		RQ_SPECIAL
+#define READ_SYNC	RQ_READ_SYNC
+#define WRITE_SYNC	RQ_WRITE_SYNC
+#define WRITE_BARRIER	RQ_WRITE_BARRIER
 
 #define SEL_IN		1
 #define SEL_OUT		2

--------------080304080801070200040800--
