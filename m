From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] ahci_xgene: Fix the error print invalid resource for APM
 X-Gene SoC AHCI SATA Host Controller driver.
Date: Mon, 15 Sep 2014 16:44:52 +0900
Message-ID: <20140915074452.GC11267@mtj.dyndns.org>
References: <1410508448-25111-1-git-send-email-stripathi@apm.com>
 <1410508448-25111-2-git-send-email-stripathi@apm.com>
 <20140912175014.GA6298@mtj.dyndns.org>
 <CAOHikRA8LiNkMuzqe-Kgrf4QWbJ_jpXRGHdf+rsrCmq6R0GjDg@mail.gmail.com>
 <20140914093911.GB9028@mtj.dyndns.org>
 <CAOHikRAFM-FETGGXroNV39Yi-jChMA-W37ufhiMx4O2WgWpxFg@mail.gmail.com>
 <CAOHikRDdfKTxCXHGsywP+c8=1eLmMCf3fuC2pmH2WH-6ymHMAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62998 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaIOHo6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Sep 2014 03:44:58 -0400
Content-Disposition: inline
In-Reply-To: <CAOHikRDdfKTxCXHGsywP+c8=1eLmMCf3fuC2pmH2WH-6ymHMAA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, patches@apm.com, Loc Ho <lho@apm.com>

On Mon, Sep 15, 2014 at 01:10:01PM +0530, Suman Tripathi wrote:
> [suman] : So the posted version is acceptable ? Any others comments on this
> patch ?

I'm suggesting setting ctx->cs_mux to NULL on failure.  IOW,

	if (res) {
		ctx->csr_mux = devm_ioremap_resources();
		if (IS_ERR(ctx->csr_mux)) {
			print warning or something;
			ctx->csr_mux = NULL;
		}
	}

Thanks.

-- 
tejun
