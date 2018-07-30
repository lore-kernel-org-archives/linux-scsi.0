From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH, RESEND] Avoid that SCSI device removal through sysfs
 triggers a deadlock
Date: Mon, 30 Jul 2018 17:50:02 +0000
Message-ID: <1dbc826ead5f8d9b84b50dd905cee834777b2628.camel@wdc.com>
References: <20180725173828.2227-1-bart.vanassche@wdc.com>
         <20180726133527.GU1934745@devbig577.frc2.facebook.com>
         <4dbd740c0555eb1bfcb4181eeaca5e397b6ab63c.camel@wdc.com>
         <20180726141435.GV1934745@devbig577.frc2.facebook.com>
         <c73204ebe4ebfbbaa652a4fda910d25c9d055ce4.camel@wdc.com>
         <20180730141345.GC1206094@devbig004.ftw2.facebook.com>
         <9761f00f237e50b40bd85c6889a297974cf9536d.camel@wdc.com>
         <20180730173126.GH1206094@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180730173126.GH1206094@devbig004.ftw2.facebook.com>
Content-Language: en-US
Content-ID: <6285579A4E67FE44AC5611C95B6CC84F@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "tj@kernel.org" <tj@kernel.org>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "oleg@redhat.com" <oleg@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-07-30 at 10:31 -0700, tj+AEA-kernel.org wrote:
+AD4- On Mon, Jul 30, 2018 at 05:28:11PM +-0000, Bart Van Assche wrote:
+AD4- +AD4- It's not clear to me how the sysfs+AF8-break+AF8-active+AF8-pro=
tection() should obtain
+AD4- +AD4- the struct kernfs+AF8-node pointer to the attribute. Calling th=
at function before
+AD4- +AD4- device+AF8-remove+AF8-file+AF8-self() causes a double call to k=
ernfs+AF8-break+AF8-active+AF8-protection(),
+AD4- +AD4- which is wrong. Calling kernfs+AF8-find+AF8-and+AF8-get(kobj-+A=
D4-sd, attr-+AD4-name) after the
+AD4-=20
+AD4- So, if you braek active protection explicitly, there's no need to cal=
l
+AD4- remove+AF8-self().  It can just use regular remove.

But how to avoid that scsi+AF8-remove+AF8-device(to+AF8-scsi+AF8-device(dev=
)) gets called
multiple times when using device+AF8-remove+AF8-self() and in case of concu=
rrent
writes into the SCSI device +ACI-delete+ACI- sysfs attribute?

Thanks,

Bart.
