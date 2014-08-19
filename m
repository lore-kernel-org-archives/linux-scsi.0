From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 3/3] ahci_xgene: Fix the link down in first attempt
 for the APM X-Gene SoC AHCI SATA host controller driver.
Date: Tue, 19 Aug 2014 11:49:12 -0400
Message-ID: <20140819154912.GC16480@htj.dyndns.org>
References: <1408429911-1406-1-git-send-email-stripathi@apm.com>
 <1408429911-1406-4-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1408429911-1406-4-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 19, 2014 at 12:01:51PM +0530, Suman Tripathi wrote:
> The link down issue in first attempt happens due to 2 H/W errata below:
> 
> 1. Due to HW errata, during speed negotiation, sometimes controller
> is not able to detect ALIGN at GEN3(6Gbps) within 54.6us results in
> a timeout. This issue can be recovered by issuing a COMRESET again.
> 
> 2. Due to HW errata, although ALIGH detection is successfull, due to
> 8b/10b and disparity BERR, sometimes the signature from the drive is
> not received successfully by the Host controller. Due to this the
> communication with the host and drive is not established due to
> locking of CDR(clock and data recovery) circuit. This issue can be
> recovered by issuing a COMRESET again.
> 
> This patch fixes the above issues by retrying the COMRESET with a
> maximum attempts of 3.

It's kinda nasty but if it's necessary.  That said, can you please
update the comment so that it actually matches the code?  Also,
Wouldn't it be better to check how the reset failed before retrying?

Thanks.

-- 
tejun
