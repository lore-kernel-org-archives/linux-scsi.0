From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2] scsi: ufs: Implement Auto-Hibern8 setup
Date: Wed, 26 Jul 2017 15:25:34 +0000
Message-ID: <1501082732.2671.5.camel@wdc.com>
References: <20170725094514.19192-1-michalx.potomski@intel.com>
         <1500996626.3031.1.camel@wdc.com>
         <C8BF859FC3044844854B2CBA1ED115C1F99AFB@HASMSX111.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:38475 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751451AbdGZP0V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2017 11:26:21 -0400
In-Reply-To: <C8BF859FC3044844854B2CBA1ED115C1F99AFB@HASMSX111.ger.corp.intel.com>
Content-Language: en-US
Content-ID: <D3C7B2998F170E4CB77B162CA095F39E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "michalx.potomski@intel.com" <michalx.potomski@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "szymonx.mielczarek@intel.com" <szymonx.mielczarek@intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>

On Tue, 2017-07-25 at 16:54 +0000, Potomski, MichalX wrote:
> On Tue, 2017-07-25 at 15:30 +0000, Bart Van Assche wrote:
> > Since I'm not familiar with the Auto-Hibern8 feature: what impact does =
it
> > have on command processing? Does it e.g. cause SCSI or TMF commands tha=
t
> > are
> > sent to the UFS device to be ignored, to fail or to time out?
>=20
> Actually behavior should be transparent for all of the higher layers, sin=
ce this
> shall be fully controlled by UFS Host, which will put UFS Device to Hiber=
n8 state,
> when it has no ongoing commands to it for set up time. If there will be a=
ny command
> UFS Host should order the Device to exit Hibern8 mode and proceed normall=
y.
>=20
> Bottom line is that in model case, it shouldn't cause any of errors menti=
oned by you.
> There is possible throughput degradation in case, if transfers are sporad=
ic in terms
> of timer, which we did set up, though. According to specification it also=
 shouldn't affect
> Hibern8 states triggered by Power Management, nor any other functionality=
.

Hello Michal,

SCSI requests can not only be initiated by user space but also by the kerne=
l
itself. Are SCSI UFS devices controlled by the SCSI disk (sd) driver? Will
SCSI requests submitted by sd_check_events() to a hibernated UFS device tim=
e
out and activate the SCSI error handler?

Thanks,

Bart.=
