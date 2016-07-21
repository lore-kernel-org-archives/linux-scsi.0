From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH resend 5/5] libata-scsi: fix MODE SELECT translation for
 Control mode page
Date: Thu, 21 Jul 2016 17:26:00 -0400
Message-ID: <20160721212600.GF23759@htj.duckdns.org>
References: <af84a796696f2f366d330595d1a818e8daeb86d8.1469126217.git.tom.ty89@gmail.com>
 <b2ae6752649bc02641d38fee75ee35a59e8466d8.1469126217.git.tom.ty89@gmail.com>
 <fc2946598c92137f65636b0fd7e50dc71a089fa1.1469126217.git.tom.ty89@gmail.com>
 <14bd98eb08ddf86be28f558817bed3cd27c397cd.1469126217.git.tom.ty89@gmail.com>
 <2ed3f3aba21a4b815e9497e6aeba497280f9f333.1469126217.git.tom.ty89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2ed3f3aba21a4b815e9497e6aeba497280f9f333.1469126217.git.tom.ty89@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tom.ty89@gmail.com
Cc: hare@suse.de, sergei.shtylyov@cogentembedded.com, arnd@arndb.de, sfr@canb.auug.org.au, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 22, 2016 at 02:41:54AM +0800, tom.ty89@gmail.com wrote:
> @@ -3854,6 +3852,8 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
>  		if (ata_mselect_control(qc, p, pg_len, &fp) < 0) {
>  			fp += hdr_len + bd_len;
>  			goto invalid_param;
> +		} else {
> +			goto skip; /* No ATA command to send */

Hmmm... I'm a bit confused.  Why is mselect_control path different
from mselect_caching in terms of qc handling?

Thanks.

-- 
tejun
