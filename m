From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2 v2] scsi: add scsi trace core function and put trace points
Date: Tue, 02 Feb 2010 18:12:00 -0500
Message-ID: <yq1636fqlkv.fsf@sermon.lab.mkp.net>
References: <4B665EC9.6000608@jp.fujitsu.com>
	<4B666181.7080200@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B666181.7080200@jp.fujitsu.com> (Kei Tokunaga's message of
	"Mon, 01 Feb 2010 14:07:13 +0900")
Sender: linux-kernel-owner@vger.kernel.org
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Frederic Weisbecker <fweisbec@gmail.com>, Martin Peterson <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Joe Perches <joe@perches.com>, Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Kei" == Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com> writes:

I'm traveling so I won't have time to look at this closely until next
week.  However, this caught my eye:

+static const char *
+scsi_trace_varlen(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	switch (SERVICE_ACTION(cdb)) {
+	case READ_32:
+	case WRITE_32:
+		/* if protection is enabled */
+		if (((cdb[10] >> 5) & 0x7) == 1)
+			return scsi_trace_rw32(p, cdb, len);
+		/* fall through */
+	default:
+		return scsi_trace_misc(p, cdb, len);
+	}
+}

It is not a requirement that a 32-byte READ/WRITE request must have
PROTECT set.  So that if statement is bogus.

-- 
Martin K. Petersen	Oracle Linux Engineering
