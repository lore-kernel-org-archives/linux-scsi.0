From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH, RESEND] Avoid that SCSI device removal through sysfs
 triggers a deadlock
Date: Mon, 30 Jul 2018 17:28:11 +0000
Message-ID: <9761f00f237e50b40bd85c6889a297974cf9536d.camel@wdc.com>
References: <20180725173828.2227-1-bart.vanassche@wdc.com>
         <20180726133527.GU1934745@devbig577.frc2.facebook.com>
         <4dbd740c0555eb1bfcb4181eeaca5e397b6ab63c.camel@wdc.com>
         <20180726141435.GV1934745@devbig577.frc2.facebook.com>
         <c73204ebe4ebfbbaa652a4fda910d25c9d055ce4.camel@wdc.com>
         <20180730141345.GC1206094@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180730141345.GC1206094@devbig004.ftw2.facebook.com>
Content-Language: en-US
Content-ID: <2C32CF00733FF24EA11EF9D081859D23@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "tj@kernel.org" <tj@kernel.org>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "oleg@redhat.com" <oleg@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-07-30 at 07:13 -0700, tj+AEA-kernel.org wrote:
+AD4- Also, wouldn't it be better to just expose sysfs+AF8-break/unbreak an=
d
+AD4- then do sth like the following from scsi?
+AD4-=20
+AD4-         kobject+AF8-get()+ADs-
+AD4- 	sysfs+AF8-break+AF8-active+AF8-protection()+ADs-
+AD4- 	do normal sysfs removal+ADs-
+AD4- 	sysfs+AF8-unbreak..()+ADs-
+AD4- 	kobject+AF8-put()+ADs-

Hello Tejun,

It's not clear to me how the sysfs+AF8-break+AF8-active+AF8-protection() sh=
ould obtain
the struct kernfs+AF8-node pointer to the attribute. Calling that function =
before
device+AF8-remove+AF8-file+AF8-self() causes a double call to kernfs+AF8-br=
eak+AF8-active+AF8-protection(),
which is wrong. Calling kernfs+AF8-find+AF8-and+AF8-get(kobj-+AD4-sd, attr-=
+AD4-name) after the
attribute has been removed results in a NULL pointer because the attribute =
that
that call tries to look up has already been removed. Should I proceed with =
the
approach proposed in the patches attached to a previous e-mail?

Thanks,

Bart.
