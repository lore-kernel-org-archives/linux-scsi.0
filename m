From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Tue, 2 Dec 2003 01:50:55 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031202095055.GB173962@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B060ED86@AVEXCH02.qlogic.org> <20031202032253.GA175030@sgi.com> <20031202101506.GB31682@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.SGI.COM ([192.48.171.6]:13737 "EHLO zok.sgi.com")
	by vger.kernel.org with ESMTP id S261775AbTLBJwp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2003 04:52:45 -0500
Content-Disposition: inline
In-Reply-To: <20031202101506.GB31682@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Jes Sorensen <jes@wildopensource.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@sgi.com, mdr@sgi.com

On Tue, Dec 02, 2003 at 02:15:06AM -0800, Andrew Vasquez wrote:
> 
> Yes, in the Linux world, the NVRAM value is irrelevent -- the driver
> will determine the ideal value based on the sizeof(dma_addr_t).  I've
> already removed the NVRAM reads of the host_p[] from
> qla2x00_nvram_config().

Okay, that sounds good.  Do I take this to mean that this whole block:

        ha->flags.disable_luns = ((nv->host_p[0] & BIT_2) ? 1 : 0);
        ha->flags.disable_risc_code_load = ((nv->host_p[0] & BIT_4) ? 1 : 0);
        ha->flags.set_cache_line_size_1 = ((nv->host_p[0] & BIT_5) ? 1 : 0);
        /*
         * enable_64bit_addressing gets set in qla2x00_config_dma_addressing;
         * do not set it here.
         * ha->flags.enable_64bit_addressing = ((nv->host_p[1] & BIT_0) ? 1 : 0);
         */
        ha->flags.enable_lip_reset = ((nv->host_p[1] & BIT_1) ? 1 : 0);
        ha->flags.enable_lip_full_login = ((nv->host_p[1] & BIT_2) ? 1 : 0);
        ha->flags.enable_target_reset = ((nv->host_p[1] & BIT_3) ? 1 : 0);
        ha->flags.enable_flash_db_update = ((nv->host_p[1] & BIT_4) ? 1 : 0);

will be gone in the next update?

When do you plan to make the next update available?

thanks,

jeremy
