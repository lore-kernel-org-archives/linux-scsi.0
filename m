From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2] scsi: ufs: Implement Auto-Hibern8 setup
Date: Thu, 27 Jul 2017 15:07:46 +0000
Message-ID: <1501168063.2516.6.camel@wdc.com>
References: <20170725094514.19192-1-michalx.potomski@intel.com>
         <1500996626.3031.1.camel@wdc.com>
         <C8BF859FC3044844854B2CBA1ED115C1F99AFB@HASMSX111.ger.corp.intel.com>
         <1501082732.2671.5.camel@wdc.com>
         <C8BF859FC3044844854B2CBA1ED115C1F99C98@HASMSX111.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:63300 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdG0PIe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2017 11:08:34 -0400
In-Reply-To: <C8BF859FC3044844854B2CBA1ED115C1F99C98@HASMSX111.ger.corp.intel.com>
Content-Language: en-US
Content-ID: <6E69388AA683E642A25636C1BDA99B43@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "michalx.potomski@intel.com" <michalx.potomski@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "szymonx.mielczarek@intel.com" <szymonx.mielczarek@intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>

Hello Michal,

Please configure your e-mail client such that it inserts a "On $(date) $(au=
thor)
wrote:" line in replies. As one can see below that line is missing from you=
r
replies.

On Thu, 2017-07-27 at 09:15 +0000, Potomski, MichalX wrote:
> > On Tue, 2017-07-25 at 16:54 +0000, Potomski, MichalX wrote:
> > > On Tue, 2017-07-25 at 15:30 +0000, Bart Van Assche wrote:
> > > > Since I'm not familiar with the Auto-Hibern8 feature: what impact
> > > > does it have on command processing? Does it e.g. cause SCSI or TMF
> > > > commands that are sent to the UFS device to be ignored, to fail or
> > > > to time out?
> > >=20
> > > Actually behavior should be transparent for all of the higher layers,
> > > since this shall be fully controlled by UFS Host, which will put UFS
> > > Device to Hibern8 state, when it has no ongoing commands to it for se=
t
> > > up time. If there will be any command UFS Host should order the Devic=
e to exit
> >=20
> > Hibern8 mode and proceed normally.
> > >=20
> > > Bottom line is that in model case, it shouldn't cause any of errors m=
entioned
> >=20
> > by you.
> > > There is possible throughput degradation in case, if transfers are
> > > sporadic in terms of timer, which we did set up, though. According to
> > > specification it also shouldn't affect
> > > Hibern8 states triggered by Power Management, nor any other functiona=
lity.
> >=20
> > Hello Michal,
> >=20
> > SCSI requests can not only be initiated by user space but also by the k=
ernel itself.
> > Are SCSI UFS devices controlled by the SCSI disk (sd) driver? Will SCSI=
 requests
> > submitted by sd_check_events() to a hibernated UFS device time out and
> > activate the SCSI error handler?
>=20
> Hello Bart,
>=20
> Technically according to JESD220B UFS 2.0 spec, available on jedec.com we=
bsite,
> this feature should work autonomously. It means, that when Device will be
> put in Hibern8 state by the host in Auto-Hibern8 procedure, actions other=
 than
> reading DME Hibern8 status will cause Host to pull the Device out of Hibe=
rn8 state
> and proceed normally. Since all requests to the Device go through Host, t=
hen
> in theory it shouldn't interfere with any request made by anyone. Obvious=
ly it
> fully depends on the UFS Host and how it implements this feature. It all =
bases on
> trust, that if anyone flagged such capability in Host, did his job well a=
nd implemented
> feature correctly.
>=20
> Just to answer your questions in short manner:
>  - Yes, it is controlled by SCSI disk driver.
>  - No, if implemented correctly in Host it shouldn't time out any request=
s. For other
>    cases we can have quirks, to disable such feature for Hosts that do no=
t support this
>    correctly (despite of being flagged with capability to do so).

If the polling that is performed by the sd driver is not stopped when a UFS
device is hibernated then that polling (sd_check_events()) will wake up a U=
FS
drive from the hibernated state. Shouldn't sd/sr polling be suspended while=
 a
UFS device is in the hibernated state?

Thanks,

Bart.=
