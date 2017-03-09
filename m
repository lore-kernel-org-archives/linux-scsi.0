From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v3 00/14] qla2xxx: Bug Fixes and updates for target.
Date: Wed, 08 Mar 2017 19:42:33 -0800
Message-ID: <1489030953.10589.40.camel@haakon3.risingtidesystems.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
         <1488760974.2808.1.camel@sandisk.com>
         <1488958492.10589.9.camel@haakon3.risingtidesystems.com>
         <1488986438.2599.1.camel@sandisk.com>
         <D4E58D9F.8A5FA%giridhar.malavali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42679 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdCIDnZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2017 22:43:25 -0500
In-Reply-To: <D4E58D9F.8A5FA%giridhar.malavali@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>

Hi Giri,

On Wed, 2017-03-08 at 18:30 +0000, Malavali, Giridhar wrote:
> 
> On 3/8/17, 7:20 AM, "Bart Van Assche" <Bart.VanAssche@sandisk.com> wrote:
> 
> >On Tue, 2017-03-07 at 23:34 -0800, Nicholas A. Bellinger wrote:
> >> Btw, the regression reported here in v2:
> >> 
> >> http://www.spinics.net/lists/target-devel/msg14348.html
> >> 
> >> is completely different from what you've reported here.
> >
> >The call traces differ but the root cause is probably the same.
> >
> >> It would be useful to explain how you reproduced this, instead of just
> >> posting backtrace with zero context..?
> >> 
> >> Can we at least identify which patch in this series is causing this..?
> >> 
> >> Also, I assume you are running this on stock v4.11-rc1 with only this
> >> qla2xxx series applied, and not all of your other stuff, right..?
> >
> >The test I ran against v4.11-rc1 + this patch series is to start LIO on a
> >system equipped with two back-to-back connected QLogic FC HBAs (no switch
> >inbetween), to load the tcm_qla2xxx driver, to configure LUNs and to wait
> >until the SCSI stack reports that these LUNs have appeared. What I see in
> >the lsscsi output with both v2 and v3 of this patch series is that these
> >LUNs appear briefly and then disappear and that a little bit later the
> >kernel reports that a hang occurred. Without this patch series the LUNs
> >are
> >detected and do not disappear automatically and no hang is reported. I
> >think the next step is that Cavium verifies whether they can reproduce
> >this
> >behavior and if they can reproduce it to run a bisect. BTW, since there
> >are
> >login-related patches in this series I wouldn't be surprised if one of
> >these
> >patches introduced the regression.
> 
> We generally go through switch. We will try to reproduce with back to back
> and bisect the patches.
> 

Just a heads up given this series mixes bug-fixes with a few other
miscellaneous improvements, I'd like to get it pushed to Linus with the
next round of patches no later than -rc3.

If it's beyond -rc3, then the bug-fixes will need to be split out for
v4.11-rc separate from the other improvements.
