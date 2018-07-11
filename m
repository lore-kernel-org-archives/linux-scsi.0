From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.18-rc3
Date: Wed, 11 Jul 2018 09:56:21 -0400
Message-ID: <16922cb7-757e-dc25-bc5a-ee6e48538b13@cybernetics.com>
References: <1530913134.3135.2.camel@HansenPartnership.com>
 <CA+55aFy-o3fRtkQnJU=0zv7CPUtgfKiwhfQi_05K25Y_-mx+_w@mail.gmail.com>
 <CA+55aFxQ8QzGTWsVdVQVok9cLbgZDFjG2g3JZtWJd+G9jHkYoQ@mail.gmail.com>
 <CA+55aFxAy__3hE1OoUFPKZfptLT1cXuoujsnSGXBMzJPQ+Qjzg@mail.gmail.com>
 <1530940958.3135.4.camel@HansenPartnership.com>
 <CA+55aFwg-2GP4ASTdd1pusmZkF7c8AN9febVDCaioDxzYJSLfw@mail.gmail.com>
 <70d566f0-2dda-60c2-7c7a-e09e371f8607@cybernetics.com>
 <20180711064542.GA7377@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711064542.GA7377@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 07/11/2018 02:45 AM, Christoph Hellwig wrote:
> On Tue, Jul 10, 2018 at 05:53:18PM -0400, Tony Battersby wrote:
>> At my job (https://www.cybernetics.com/), I use the write()/read()
>> interface to the SCSI generic driver for access to tape drives and tape
>> medium changers.  For example, the write()/read() interface is useful
>> for implementing RAID-like functionality for tape drives since a single
>> thread can send commands to multiple tape drives at once and poll() for
>> command completion.  We have a lot of code invested in this interface,
>> so it would be a huge pain for us if it were removed.  But in our case,
>> everything runs as root (as the firmware of an embedded storage
>> appliance), so extra permission checks should be OK.
> Do you just use read/write on /dev/sg or also on /dev/bsg?  Because
> I started a discussion to kill the read/write support for the latter
> even before Linus brought it up here..  (and we have the same fix
> pending for /dev/bsg)
>
The read/write interface on /dev/bsg is impossible to use safely because
the list of completed commands is per-device (bd->done_list) rather than
per-fd like it is with /dev/sg.  So if program A and program B are both
using the write/read interface on the same bsg device, then their
command responses will get mixed up, and program A will read() some
command results from program B and vice versa.  So no, I don't use
read/write on /dev/bsg.  From a security standpoint, it should
definitely be fixed or removed.

Another issue with the read/write interface of /dev/bsg was this:

[PATCH] [SCSI] bsg: fix unkillable I/O wait deadlock with scsi-mq
https://marc.info/?l=linux-scsi&m=142367231311098&w=2

My similar patch to sg.c was accepted as commit 7568615c1054 ("sg: fix
unkillable I/O wait deadlock with scsi-mq"), but my bsg patch was never
applied.  I do not know if the problem still exists in the current
kernel or if some other change to scsi-mq has fixed it.  I do have a
forward-port of the patch to 4.16, but it no longer applies to 4.17.

---

A while ago there was a commit that broke the read/write interface of
/dev/sg (but not SG_IO), and some other people complained in the
following bugzilla entry, indicating that there are other users also:

https://bugzilla.kernel.org/show_bug.cgi?id=198081

The commit that broke it was:
109bade9c625 ("scsi: sg: use standard lists for sg_requests")

The commit that fixed it was:
48ae8484e9fc ("scsi: sg: don't return bogus Sg_requests")
(sg_get_rq_mark() is called only from sg_read(), so if the patch fixed
the problem that people were complaining about in bugzilla, then that
indicates that they are using the read/write interface also)

See my explanation here:
https://marc.info/?l=linux-scsi&m=152227354106242
(basically, the commit that broke it got backported to -stable, but the
fix didn't, so various -stable kernels were broken for a while, and
people complained)

Tony Battersby
Cybernetics
