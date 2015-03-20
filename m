From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [Scst-devel] scst qla2xxx.ko  VS kernel qla2xxx.ko
Date: Fri, 20 Mar 2015 13:33:37 -0700
Message-ID: <550C8421.2010702@sandisk.com>
References: <201503202005.t2KK5qSs019140@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0090.outbound.protection.outlook.com ([207.46.100.90]:59654
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751064AbbCTUdn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Mar 2015 16:33:43 -0400
In-Reply-To: <201503202005.t2KK5qSs019140@wind.enjellic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "greg@enjellic.com" <greg@enjellic.com>, Suresh Babu Kandukuru <suresh.babu.kandukuru@oracle.com>, "scst-devel@lists.sourceforge.net" <scst-devel@lists.sourceforge.net>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/20/2015 01:06 PM, Dr. Greg Wettstein wrote:
> We have had the opportunity to architect, build, maintain and debug
> complex converged data and storage networks.  The switches on these
> networks are a million dollars apiece and there are multiple switches
> in multiple data-centers.
>
> The storage, running at about one-half petabyte levels, is all SCST
> based and we use Qlogic HBA's and CNA's on both the initiators and
> targets.  Given the somewhat colorful history with respect to Qlogic
> target driver support we had to roll up our sleeves and write an
> interface driver which allows SCST to run on top of the Qlogic target
> driver in stock Linux kernels.
>
> I just put an integrated patchset which includes SCST 3.0.0, our
> target interface driver and a few patches to the in-kernel target
> driver we carry to make all of this work correctly and address various
> regressions in the stock target driver.  You can grab the patchset
> from the following URL:
>
> ftp://ftp.enjellic.com/pub/scst/sqa-1.2_scst-3.0.0_3.10.67.patch.gz
>
> All of the storage targets are direct FCOE attachments using Qlogic
> 8362 CNA's.  The above patchset is what we are currently using in
> production and it has been validated over hundreds and hundreds of
> terrabytes of I/O, which includes exposure to some rather rigorous
> fabric and TMF event processing situations.  We have also tracked down
> some rather elusive switch based FCOE transport issues with this
> codebase.
>
> Obviously your mileage may vary.
>
> If you drop the above patch onto a 3.10 kernel source tree and build a
> kernel with the appropriate configuration options it should work with
> whatever cards are supported by the stock Linux kernel.  One of the
> patches which is included sets the card to QLA2XXX_INI_MODE_EXCLUSIVE
> which causes the card to come up 'target capable' by default which
> mirrors the behavior of the SCST supplied Qlogic target driver.
>
> In your note you indicate your card is a 'QLogic QLE8362 - 7101674,
> Sun Storage 16Gb FC PCIe Universal HBA' which I assume is probably an
> OEM rebranded card.  The 8362 is actually a Converged Network Adapter
> (CNA) rather then an HBA.  The 2672 is the 'fibre-channel' HBA version
> of the card.  The stock Qlogic cards are dual-personality cards which
> allows their operational mode, ie 16 GBPS FC or 10 GBPS ethernet, to
> be selected through the BIOS setup utilities.
>
> Given your e-mail address, I'm sure you've jumped through all these
> hoops but one obviously wants to have the card setup with the right
> personality and correct optics for your physical transport layer.
>
> You also probably want to make sure you have both your HBA/CNA and
> motherboard up to the most recent versions of their respective
> firmware.  There are issues particularly with Intel S2600 motherboards
> and these cards which requires updated firmware on both sides.
>
> If the card is detected and found to be target capable by the stock
> Linux kernel Qlogic driver you will find the available target PWWN's
> in the following directory:
>
> /sys/kernel/scst_tgt/targets/sqatgt
>
> If there are none present there is the possibility that the card has
> been modified in firmware to prohibit target mode or has a modified
> PCI id which is causing problems for the driver probe logic.  If that
> is the case the card isn't going to be a candidate for use in target
> mode.  We tend to recommend that people buy straight Qlogic branded
> cards to avoid these sorts of issues.
>
> Just as an FYI/CYA there are session management issues/bugs in the
> Qlogic target driver, regardless of breed; SCST, Qlogic SCST or
> kernel.  These can show up during asynchronous fabric processing
> events, particularly if you are aggressive in placing the card and
> fabric under duress.
>
> We are in the process of upgrading our patchset to 3.0.1 which will
> include a number of additional fixes to the in-kernel Qlogic target
> driver.  I will shoot a note off to the list when it is available if
> you or others find this stuff useful.
>
> I hope the above is helpful.

Hello Greg,

Having to download an SCST target driver that is not in the SCST tree is 
inconvenient for SCST users. If we would add your version of the SCST 
QLogic target driver in the SCST tree, would you be willing to maintain 
that target driver ? We can provide help to make sure that that driver 
builds against multiple kernel versions. If you want I can send you a 
copy of the output of the SCST nightly build process. That nightly build 
process checks whether SCST and its target drivers build correctly 
against a wide range of kernel versions.

Bart.
