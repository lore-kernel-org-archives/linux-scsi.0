From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 3/6] [SCSI] runtime resume device before system suspend
Date: Thu, 24 Nov 2011 15:01:10 -0800
Message-ID: <CAOS58YMCv0syM7ggzaJeQp6oQxdNAJ9Y5Yn+6Q_Tb7ZjcvPzng@mail.gmail.com>
References: <20111124195703.GA6735@google.com>
	<Pine.LNX.4.44L0.1111241735300.26861-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1111241735300.26861-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lin Ming <ming.m.lin@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Nov 24, 2011 at 2:54 PM, Alan Stern <stern@rowland.harvard.edu>=
 wrote:
> Therefore, when entering the SUSPEND or HIBERNATE stages of system
> sleep, we can skip the callback to the driver if the device is alread=
y
> in runtime suspend. =A0When entering the FREEZE stage, however, we sh=
ould
> first issue a runtime resume. =A0The overhead of doing this is
> negligible, because a suspended drive would be spun up during the THA=
W
> stage of hibernation anyway.

My brain is half fried at the moment so maybe you're saying the same
thing, but I hope this is something simple. Like...

    /* for libata runtime suspend is equivalent to suspend */
    if (runtime suspended && target =3D=3D SUSPEND) {
        yeah! skip drive pm ops;
    } else {
        end runtime pm;
        ask EH to enter target PM state;
    }

I really don't think we need to optimize this further than this.

Thanks.

--=20
tejun
