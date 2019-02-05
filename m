From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH v3 5/5] Revert "scsi: ufs: disable vccq if it's not needed
 by UFS device"
Date: Tue, 5 Feb 2019 10:19:01 -0800
Message-ID: <CAE=gft5yAqLZDnYnjF2T1QbKfOKOagX+C1qQqD1DFU+2pr_WPw@mail.gmail.com>
References: <e3c82a49-c601-effc-348f-f768656c659f@free.fr> <CGME20190204174549epcas4p4682667176f55101f69cc24cc455c9f3c@epcas4p4.samsung.com>
 <70618c25-83f0-b9db-51a3-c1d74b605a45@free.fr> <5f2a8378-1f22-6a52-356d-56d3b393ab1d@samsung.com>
 <05d2d193-4181-12ce-b4fb-4e8dec5aef27@free.fr> <7610c262-1451-9bb2-48a6-4daf6f534f6c@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7610c262-1451-9bb2-48a6-4daf6f534f6c@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, MSM <linux-arm-msm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Douglas Anderson <dianders@chromium.org>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Subhash Jadavani <subhashj@codeaurora.org>, Bart Van Assche <bvanassche@acm.org>, SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 5, 2019 at 9:52 AM Marc Gonzalez <marc.w.gonzalez@free.fr> wrote:
>
> On 05/02/2019 18:24, Marc Gonzalez wrote:
>
> > /*** system hangs here for several seconds, then reboots ***/
>
> Silly me. The system crashes in ufshcd_dump_regs() which is a bug
> I fixed myself. Once I cherry-pick the appropriate fix, the board
> no longer reboots, but UFS init does fail.
>
> Full boot log here:
> https://pastebin.ubuntu.com/p/KwpRnWMFw5/
>
> In any case, it's obvious that disabling vccq on this system is
> a mistake. How would you solve the problem? (A quirk on top of a
> quirk sounds silly.)
>

I think Bjorn is right that this whole quirk seems to be compensating
for an incorrectly specified device tree (one that specifies
vccq-supply but that doesn't go anywhere).... though maybe this was
made to support boards with footprint-compatible UFS parts from
different vendors? Like the same DT is used for two different SKUs,
one which stamps down a UFS part that uses VCCQ, and another that
doesn't use it, though the wire is there.

But the revert itself shouldn't really fix anything for you Marc,
should it? It looks like this quirk turns on for Samsung and SKHynix
parts, which presumably just don't use VCCQ. So maybe your device tree
doesn't match your schematics, where the DT's vccq supply is actually
the vccq2 supply going into the UFS chip?
-Evan
