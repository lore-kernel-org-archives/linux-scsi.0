From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Tue, 5 Feb 2008 13:00:02 -0800 (PST)
Message-ID: <57069.55058.qm@web31801.mail.mud.yahoo.com>
References: <20080205131920.GA7901@ubuntu.domain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:22201 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760347AbYBEVAJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 16:00:09 -0500
In-Reply-To: <20080205131920.GA7901@ubuntu.domain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Ke Wei <kewei.mv@gmail.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com, kewei@marvell.com

--- On Tue, 2/5/08, Ke Wei <kewei.mv@gmail.com> wrote:
> +	for_each_phy(port->wide_port_phymap, no, j, mvi->chip->n_phy) {
> +		mvs_write_port_cfg_addr(mvi, no, PHYR_WIDE_PORT);
> +		mvs_write_port_cfg_data(mvi, no , port->wide_port_phymap);
> +	} else {
> +		mvs_write_port_cfg_addr(mvi, no, PHYR_WIDE_PORT);
> +		mvs_write_port_cfg_data(mvi, no , 0);
> +	}
> +}

Don't do this.  Make the "if" explicit.

Since I can see you've taken this verbatim from the SAS code,
if "no" means number, then it is "j". "no" is just a temporary
register which gets shifted right each iteration and not of
much use outside the macro.

Also if "__rest" (which you added to the macro) is 0, then nether
statement would execute, which is probably not what you want.

If "n_phy" means "number of phys", then its usage that you added
into the macro is inconsistent. Furthermore it shouldn't be
necessary since wide_port_phymap & ~((2^n_phy)-1) must never be true.

    Luben

