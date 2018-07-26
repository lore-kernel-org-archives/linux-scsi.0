From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH, RESEND] Avoid that SCSI device removal through sysfs
 triggers a deadlock
Date: Thu, 26 Jul 2018 14:09:41 +0000
Message-ID: <4dbd740c0555eb1bfcb4181eeaca5e397b6ab63c.camel@wdc.com>
References: <20180725173828.2227-1-bart.vanassche@wdc.com>
         <20180726133527.GU1934745@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180726133527.GU1934745@devbig577.frc2.facebook.com>
Content-Language: en-US
Content-ID: <7274BEAAE7A2544CAC469E062E9BDB48@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "tj@kernel.org" <tj@kernel.org>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "oleg@redhat.com" <oleg@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2018-07-26 at 06:35 -0700, Tejun Heo wrote:
+AD4- Making removal asynchronous this way sometimes causes issues because
+AD4- whether the user sees the device released or not is racy.
+AD4- kernfs/sysfs have mechanisms to deal with these cases - remove+AF8-se=
lf
+AD4- and kernfs+AF8-break+AF8-active+AF8-protection().  Have you looked at=
 those?

Hello Tejun,

The call stack in the patch description shows that sdev+AF8-store+AF8-delet=
e() is
involved in the deadlock. The implementation of that function is as follows=
:

static ssize+AF8-t
sdev+AF8-store+AF8-delete(struct device +ACo-dev, struct device+AF8-attribu=
te +ACo-attr,
		  const char +ACo-buf, size+AF8-t count)
+AHs-
	if (device+AF8-remove+AF8-file+AF8-self(dev, attr))
		scsi+AF8-remove+AF8-device(to+AF8-scsi+AF8-device(dev))+ADs-
	return count+ADs-
+AH0AOw-

device+AF8-remove+AF8-file+AF8-self() calls sysfs+AF8-remove+AF8-file+AF8-s=
elf() and that last
function calls kernfs+AF8-remove+AF8-self(). In other words, kernfs+AF8-rem=
ove+AF8-self()
is already being used. Please let me know if I misunderstood your comment.

Thanks,

Bart.
