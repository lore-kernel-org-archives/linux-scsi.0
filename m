From: "tj@kernel.org" <tj@kernel.org>
Subject: Re: [PATCH, RESEND] Avoid that SCSI device removal through sysfs
 triggers a deadlock
Date: Mon, 30 Jul 2018 10:31:26 -0700
Message-ID: <20180730173126.GH1206094@devbig004.ftw2.facebook.com>
References: <20180725173828.2227-1-bart.vanassche@wdc.com>
 <20180726133527.GU1934745@devbig577.frc2.facebook.com>
 <4dbd740c0555eb1bfcb4181eeaca5e397b6ab63c.camel@wdc.com>
 <20180726141435.GV1934745@devbig577.frc2.facebook.com>
 <c73204ebe4ebfbbaa652a4fda910d25c9d055ce4.camel@wdc.com>
 <20180730141345.GC1206094@devbig004.ftw2.facebook.com>
 <9761f00f237e50b40bd85c6889a297974cf9536d.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9761f00f237e50b40bd85c6889a297974cf9536d.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "oleg@redhat.com" <oleg@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Bart.

On Mon, Jul 30, 2018 at 05:28:11PM +0000, Bart Van Assche wrote:
> It's not clear to me how the sysfs_break_active_protection() should obtain
> the struct kernfs_node pointer to the attribute. Calling that function before
> device_remove_file_self() causes a double call to kernfs_break_active_protection(),
> which is wrong. Calling kernfs_find_and_get(kobj->sd, attr->name) after the

So, if you braek active protection explicitly, there's no need to call
remove_self().  It can just use regular remove.

> attribute has been removed results in a NULL pointer because the attribute that
> that call tries to look up has already been removed. Should I proceed with the
> approach proposed in the patches attached to a previous e-mail?

I don't have an objection for that.

Thanks.

-- 
tejun
