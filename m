From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V5 2/2] scsi: ufs: Add configfs support for ufs
 provisioning
Date: Tue, 17 Jul 2018 21:06:35 +0000
Message-ID: <aa697186c00937c18519fe5eb1355d3fc458cfb6.camel@wdc.com>
References: <1530858040-13971-1-git-send-email-sayalil@codeaurora.org>
         <1530858040-13971-3-git-send-email-sayalil@codeaurora.org>
         <CAE=gft5U1-Jo-GvTF7sNAV3Q565AmuUrHpmBdxUL+UwkKxesqA@mail.gmail.com>
         <0dce9e9c-4f93-9857-72ee-f65ff195c41a@codeaurora.org>
         <CAE=gft6_=SQjgv7_kHXKJKa8_45NKKFwwE7UaXsijPpMd35LOg@mail.gmail.com>
         <4cb931e199599314829f5ff750797c88fc123f1f.camel@wdc.com>
         <CAE=gft6zm2mw3rnNuktDe0NWs-NM1CFQw1BUeGhaBi3eoEDXBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE=gft6zm2mw3rnNuktDe0NWs-NM1CFQw1BUeGhaBi3eoEDXBg@mail.gmail.com>
Content-Language: en-US
Content-ID: <3B7F1202B91B544A8F3C950A9A38DADB@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "evgreen@chromium.org" <evgreen@chromium.org>
Cc: "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>, "sayalil@codeaurora.org" <sayalil@codeaurora.org>, "riteshh@codeaurora.org" <riteshh@codeaurora.org>, "cang@codeaurora.org" <cang@codeaurora.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>, "rnayak@codeaurora.org" <rnayak@codeaurora.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2018-07-17 at 13:23 -0700, Evan Green wrote:
+AD4- On Mon, Jul 16, 2018 at 5:04 PM Bart Van Assche +ADw-Bart.VanAssche+A=
EA-wdc.com+AD4- wrote:
+AD4- +AD4-=20
+AD4- +AD4- On Mon, 2018-07-16 at 16:46 -0700, Evan Green wrote:
+AD4- +AD4- +AD4- I see Bart has chimed in on the next series with a sugges=
tion to break
+AD4- +AD4- +AD4- out each field into individual files within configfs. Bar=
t, what are
+AD4- +AD4- +AD4- your feelings about converting to a binary attribute? I r=
emember when
+AD4- +AD4- +AD4- I did my sysfs equivalent of this patch, somebody chimed =
in indicating
+AD4- +AD4- +AD4- a +ACI-commit+ACI- file might be needed so that the new c=
onfiguration could be
+AD4- +AD4- +AD4- written in one fell swoop. One advantage of the binary at=
tribute is
+AD4- +AD4- +AD4- that it writes the configuration atomically.
+AD4- +AD4-=20
+AD4- +AD4- Hello Evan,
+AD4- +AD4-=20
+AD4- +AD4- I may be missing some UFS background information. But since a c=
onfigfs interface
+AD4- +AD4- is being added I think the same rule applies as to all Linux ke=
rnel user space
+AD4- +AD4- interfaces, namely that it should be backwards compatible. Addi=
tionally, if
+AD4- +AD4- anyone ever will want to use this interface from a shell script=
, I think that
+AD4- +AD4- it will be much easier to write multiple ASCII attributes than =
a single binary
+AD4- +AD4- attribute.
+AD4- +AD4-=20
+AD4-=20
+AD4- Hi Bart,
+AD4- I'm unsure about the compatibility aspect for binary attributes that
+AD4- essentially represent direct windows into hardware. I suppose this
+AD4- comes down to who this interface is most useful to. Hypothetically
+AD4- lets say a future revision of UFS adds fields to the configuration
+AD4- descriptor, but is otherwise backwards compatible. If this interface
+AD4- is primarily for OEMs initializing their devices in the factory, then
+AD4- I'd argue they'd want the most direct window to the configuration
+AD4- descriptor. These folks probably just have a configuration they want
+AD4- to plunk into the hardware, and would prefer being able to write all
+AD4- fields over having some sort of compatibility restriction. If, on the
+AD4- other hand, this is used by long-running scripts that stick around fo=
r
+AD4- years without modification, then yes, it seems like it would be more
+AD4- important to stay compatible, and have smarts in the kernel to make
+AD4- writes of old descriptors work in new devices.
+AD4-=20
+AD4- At least for myself, I fall into the category of someone who just
+AD4- needs to plunk a configuration descriptor in once, and would prefer
+AD4- not to have to submit kernel changes if the descriptor evolves
+AD4- slightly. It also seemed a little odd that this patch now spends a
+AD4- bunch of energy converting ASCII into bytes, just to write it without
+AD4- modification into the hardware, and convert back again to ASCII for
+AD4- reads.
+AD4-=20
+AD4- We plan to use a script for provisioning, and could easily handle
+AD4- ASCII or rawbytes:
+AD4-=20
+AD4- +ACM- Some bytes, ready to go with the interface today...
+AD4- some+AF8-bytes+AD0AIg-00 01 02 03+ACI-
+AD4-=20
+AD4- +ACM- Same bytes, now in binary format
+AD4- bytes+AF8-fmt+AD0AJA-(echo +ACI- +ACQ-some+AF8-bytes+ACI- +AHw- sed '=
s/ /+AFwAXA-x/g')
+AD4- /usr/bin/printf +ACIAJA-bytes+AF8-fmt+ACI- +AD4- /configfs/ufs+AF8-pr=
ovision
+AD4-=20
+AD4- I'm not dead set on binary, since as above I could do it either way,
+AD4- but it seemed worth at least talking through. Let me know what you
+AD4- think.

The configfs documentation (Documentation/filesystems/configfs/configfs.txt=
)
is clear about this: +ACI-Preferably only one value per file should be used=
.+ACI- So
I would like to hear the opinion of someone who has more authority than I
with regard to configfs.

Bart.=
