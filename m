From: Jeffrey Hugo <jhugo@codeaurora.org>
Subject: Re: [PATCH v3 5/5] Revert "scsi: ufs: disable vccq if it's not needed
 by UFS device"
Date: Tue, 5 Feb 2019 12:37:26 -0700
Message-ID: <fe4e6e20-2017-0a50-232d-52582983146d@codeaurora.org>
References: <e3c82a49-c601-effc-348f-f768656c659f@free.fr>
 <CGME20190204174549epcas4p4682667176f55101f69cc24cc455c9f3c@epcas4p4.samsung.com>
 <70618c25-83f0-b9db-51a3-c1d74b605a45@free.fr>
 <5f2a8378-1f22-6a52-356d-56d3b393ab1d@samsung.com>
 <05d2d193-4181-12ce-b4fb-4e8dec5aef27@free.fr>
 <7610c262-1451-9bb2-48a6-4daf6f534f6c@free.fr>
 <CAE=gft5yAqLZDnYnjF2T1QbKfOKOagX+C1qQqD1DFU+2pr_WPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE=gft5yAqLZDnYnjF2T1QbKfOKOagX+C1qQqD1DFU+2pr_WPw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>, Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, MSM <linux-arm-msm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Douglas Anderson <dianders@chromium.org>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Subhash Jadavani <subhashj@codeaurora.org>, Bart Van Assche <bvanassche@acm.org>, SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2/5/2019 11:19 AM, Evan Green wrote:
> On Tue, Feb 5, 2019 at 9:52 AM Marc Gonzalez <marc.w.gonzalez@free.fr> wrote:
>>
>> On 05/02/2019 18:24, Marc Gonzalez wrote:
>>
>>> /*** system hangs here for several seconds, then reboots ***/
>>
>> Silly me. The system crashes in ufshcd_dump_regs() which is a bug
>> I fixed myself. Once I cherry-pick the appropriate fix, the board
>> no longer reboots, but UFS init does fail.
>>
>> Full boot log here:
>> https://pastebin.ubuntu.com/p/KwpRnWMFw5/
>>
>> In any case, it's obvious that disabling vccq on this system is
>> a mistake. How would you solve the problem? (A quirk on top of a
>> quirk sounds silly.)
>>
> 
> I think Bjorn is right that this whole quirk seems to be compensating
> for an incorrectly specified device tree (one that specifies
> vccq-supply but that doesn't go anywhere).... though maybe this was
> made to support boards with footprint-compatible UFS parts from
> different vendors? Like the same DT is used for two different SKUs,
> one which stamps down a UFS part that uses VCCQ, and another that
> doesn't use it, though the wire is there.

This doesn't make sense from a DT perspective, as I understand it.  If 
some board has different configurations (say different display panels), 
FW is supposed to somehow detect that, and edit the DT before passing 
the DT off to Linux.

In your example, if SKU1 has a UFS part that needs VCCQ, and SKU2 does 
not, then FW should somehow query the HW, determine which SKU the device 
is, and patch vccq in or out of the DT as necessary.

> 
> But the revert itself shouldn't really fix anything for you Marc,
> should it? It looks like this quirk turns on for Samsung and SKHynix
> parts, which presumably just don't use VCCQ. So maybe your device tree
> doesn't match your schematics, where the DT's vccq supply is actually
> the vccq2 supply going into the UFS chip?

I see the same issue on the reference device, the MSM8998 MTP.  The 
schematics for that indicate there is both vccq and vccq2, at different 
voltages.  vccq goes to both the UFS block, and the phy.

Digging into things, the problem doesn't seem to be that vccq is off - 
the phy will keep it on.  However, the load from the phy is minimal. 
What really loads the regulator is the UFS block.  Without the load from 
the UFS block, the regulator is likely in a low power mode.

I cannot tell if vccq is routed to the actual storage chip based on the 
documentation I see, however I can tell that it powers blocks within the 
host controller block which assist the controller in communicating with 
the storage chip.  These blocks consume quite a bit of power, so likely, 
if the regulator load is not properly accounted for, these blocks 
brownout, and communication with the storage chip is broken.

The schematics do refer to this input to the UFS block as "vccq".

So, at a minimum, the host controller itself consumes vccq, and 
therefore it is unfair to disable vccq solely based on the UFS storage 
chip that happens to be connected to the controller.

So, we've got two boards that are actually harmed by this quirk.  I've 
not seen anything indicating what harm happens without this quirk.  Can 
someone indicate what that is?

-- 
Jeffrey Hugo
Qualcomm Datacenter Technologies as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
