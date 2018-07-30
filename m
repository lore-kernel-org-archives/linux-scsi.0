From: "tj@kernel.org" <tj@kernel.org>
Subject: Re: [PATCH, RESEND] Avoid that SCSI device removal through sysfs
 triggers a deadlock
Date: Mon, 30 Jul 2018 07:13:45 -0700
Message-ID: <20180730141345.GC1206094@devbig004.ftw2.facebook.com>
References: <20180725173828.2227-1-bart.vanassche@wdc.com>
 <20180726133527.GU1934745@devbig577.frc2.facebook.com>
 <4dbd740c0555eb1bfcb4181eeaca5e397b6ab63c.camel@wdc.com>
 <20180726141435.GV1934745@devbig577.frc2.facebook.com>
 <c73204ebe4ebfbbaa652a4fda910d25c9d055ce4.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c73204ebe4ebfbbaa652a4fda910d25c9d055ce4.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "oleg@redhat.com" <oleg@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Bart.

On Thu, Jul 26, 2018 at 09:57:40PM +0000, Bart Van Assche wrote:
...
> @@ -440,11 +445,21 @@ bool sysfs_remove_file_self(struct kobject *kobj, const struct attribute *attr)
>  		return false;
>  
>  	ret = kernfs_remove_self(kn);
> +	if (ret && cb) {
> +		kernfs_break_active_protection(kn);
> +		cb(kobj, attr, data);
> +		kernfs_break_active_protection(kn);

unbreak?

Also, wouldn't it be better to just expose sysfs_break/unbreak and
then do sth like the following from scsi?

        kobject_get();
	sysfs_break_active_protection();
	do normal sysfs removal;
	sysfs_unbreak..();
	kobject_put();

Thanks.

-- 
tejun
