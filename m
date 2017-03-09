From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v3 00/14] qla2xxx: Bug Fixes and updates for target.
Date: Wed, 08 Mar 2017 19:38:10 -0800
Message-ID: <1489030690.10589.35.camel@haakon3.risingtidesystems.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
         <1488760974.2808.1.camel@sandisk.com>
         <1488958492.10589.9.camel@haakon3.risingtidesystems.com>
         <1488986438.2599.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47307 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdCIDiW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2017 22:38:22 -0500
In-Reply-To: <1488986438.2599.1.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>

On Wed, 2017-03-08 at 15:20 +0000, Bart Van Assche wrote:
> On Tue, 2017-03-07 at 23:34 -0800, Nicholas A. Bellinger wrote:
> > Btw, the regression reported here in v2:
> > 
> > http://www.spinics.net/lists/target-devel/msg14348.html
> > 
> > is completely different from what you've reported here.
> 
> The call traces differ but the root cause is probably the same.
> 
> > It would be useful to explain how you reproduced this, instead of just
> > posting backtrace with zero context..?
> > 
> > Can we at least identify which patch in this series is causing this..?
> > 
> > Also, I assume you are running this on stock v4.11-rc1 with only this
> > qla2xxx series applied, and not all of your other stuff, right..?
> 
> The test I ran against v4.11-rc1 + this patch series is to start LIO on a
> system equipped with two back-to-back connected QLogic FC HBAs (no switch
> inbetween), to load the tcm_qla2xxx driver, to configure LUNs and to wait
> until the SCSI stack reports that these LUNs have appeared. What I see in
> the lsscsi output with both v2 and v3 of this patch series is that these
> LUNs appear briefly and then disappear and that a little bit later the
> kernel reports that a hang occurred. Without this patch series the LUNs are
> detected and do not disappear automatically and no hang is reported. I
> think the next step is that Cavium verifies whether they can reproduce this
> behavior and if they can reproduce it to run a bisect. BTW, since there are
> login-related patches in this series I wouldn't be surprised if one of these
> patches introduced the regression.
> 

Good.  Thanks for confirming it's with a PTP setup, and atop stock
v4.11-rc1 with this series.
