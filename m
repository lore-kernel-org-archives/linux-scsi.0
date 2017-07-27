From: "Potomski, MichalX" <michalx.potomski@intel.com>
Subject: RE: [PATCH v2] scsi: ufs: Implement Auto-Hibern8 setup
Date: Thu, 27 Jul 2017 09:15:53 +0000
Message-ID: <C8BF859FC3044844854B2CBA1ED115C1F99C98@HASMSX111.ger.corp.intel.com>
References: <20170725094514.19192-1-michalx.potomski@intel.com>
         <1500996626.3031.1.camel@wdc.com>
         <C8BF859FC3044844854B2CBA1ED115C1F99AFB@HASMSX111.ger.corp.intel.com>
 <1501082732.2671.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:65022 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750878AbdG0JP5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Jul 2017 05:15:57 -0400
In-Reply-To: <1501082732.2671.5.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "Mielczarek, SzymonX" <szymonx.mielczarek@intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>

> On Tue, 2017-07-25 at 16:54 +0000, Potomski, MichalX wrote:
> > On Tue, 2017-07-25 at 15:30 +0000, Bart Van Assche wrote:
> > > Since I'm not familiar with the Auto-Hibern8 feature: what impact
> > > does it have on command processing? Does it e.g. cause SCSI or TMF
> > > commands that are sent to the UFS device to be ignored, to fail or
> > > to time out?
> >
> > Actually behavior should be transparent for all of the higher layers,
> > since this shall be fully controlled by UFS Host, which will put UFS
> > Device to Hibern8 state, when it has no ongoing commands to it for set
> > up time. If there will be any command UFS Host should order the Device to exit
> Hibern8 mode and proceed normally.
> >
> > Bottom line is that in model case, it shouldn't cause any of errors mentioned
> by you.
> > There is possible throughput degradation in case, if transfers are
> > sporadic in terms of timer, which we did set up, though. According to
> > specification it also shouldn't affect
> > Hibern8 states triggered by Power Management, nor any other functionality.
> 
> Hello Michal,
> 
> SCSI requests can not only be initiated by user space but also by the kernel itself.
> Are SCSI UFS devices controlled by the SCSI disk (sd) driver? Will SCSI requests
> submitted by sd_check_events() to a hibernated UFS device time out and
> activate the SCSI error handler?

Hello Bart,

Technically according to JESD220B UFS 2.0 spec, available on jedec.com website,
this feature should work autonomously. It means, that when Device will be
put in Hibern8 state by the host in Auto-Hibern8 procedure, actions other than
reading DME Hibern8 status will cause Host to pull the Device out of Hibern8 state
and proceed normally. Since all requests to the Device go through Host, then
in theory it shouldn't interfere with any request made by anyone. Obviously it
fully depends on the UFS Host and how it implements this feature. It all bases on
trust, that if anyone flagged such capability in Host, did his job well and implemented
feature correctly.

Just to answer your questions in short manner:
 - Yes, it is controlled by SCSI disk driver.
 - No, if implemented correctly in Host it shouldn't time out any requests. For other
   cases we can have quirks, to disable such feature for Hosts that do not support this
   correctly (despite of being flagged with capability to do so).
> 
> Thanks,
> 
> Bart.
Cheers,
Michal
--------------------------------------------------------------------

Intel Technology Poland sp. z o.o.
ul. Slowackiego 173 | 80-298 Gdansk | Sad Rejonowy Gdansk Polnoc | VII Wydzial Gospodarczy Krajowego Rejestru Sadowego - KRS 101882 | NIP 957-07-52-316 | Kapital zakladowy 200.000 PLN.

Ta wiadomosc wraz z zalacznikami jest przeznaczona dla okreslonego adresata i moze zawierac informacje poufne. W razie przypadkowego otrzymania tej wiadomosci, prosimy o powiadomienie nadawcy oraz trwale jej usuniecie; jakiekolwiek
przegladanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). If you are not the intended recipient, please contact the sender and delete all copies; any review or distribution by
others is strictly prohibited.
