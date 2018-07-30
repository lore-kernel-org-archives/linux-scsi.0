From: "tj@kernel.org" <tj@kernel.org>
Subject: Re: [PATCH, RESEND] Avoid that SCSI device removal through sysfs
 triggers a deadlock
Date: Mon, 30 Jul 2018 07:17:46 -0700
Message-ID: <20180730141746.GD1206094@devbig004.ftw2.facebook.com>
References: <20180725173828.2227-1-bart.vanassche@wdc.com>
 <20180726133527.GU1934745@devbig577.frc2.facebook.com>
 <c313b5f09b6636fe71eb0a6c7390c3ef51869ae7.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c313b5f09b6636fe71eb0a6c7390c3ef51869ae7.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "oleg@redhat.com" <oleg@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jul 29, 2018 at 04:03:41AM +0000, Bart Van Assche wrote:
> On Thu, 2018-07-26 at 06:35 -0700, Tejun Heo wrote:
> > Making removal asynchronous this way sometimes causes issues because
> > whether the user sees the device released or not is racy.
> 
> Hello Tejun,
> 
> How could this change cause any user-visible changes? My understanding is
> that any work queued with task_work_add() is executed before system call
> execution leaves kernel context and returns back to user space context.

Ah, you're right.  This isn't workqueue.  Hmm... yeah, needing to
allocate sth in removal path is a bit icky but, it should be okay I
guess.  I *think* the kernfs active break/unbreak is likely gonna be
cleaner tho.

Thanks.

-- 
tejun
