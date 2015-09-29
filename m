From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 27/32] cxlflash: Fix to prevent stale AFU RRQ
Date: Tue, 29 Sep 2015 11:36:32 +1000
Message-ID: <8737xyuhun.fsf@gamma.ozlabs.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443223144-9962-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35788 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbbI2Bgq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2015 21:36:46 -0400
Received: by pacfv12 with SMTP id fv12so193900436pac.2
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2015 18:36:45 -0700 (PDT)
In-Reply-To: <1443223144-9962-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

"Matthew R. Ochs" <mrochs@linux.vnet.ibm.com> writes:

> Following an adapter reset, the AFU RRQ that resides in host memory
> holds stale data. This can lead to a condition where the RRQ interrupt
> handler tries to process stale entries and/or endlessly loops due to an
> out of sync generation bit.
>
> To fix, the AFU RRQ in host memory needs to be cleared after each reset.

This looks good. Do you need anything to bail out of cxlflash_rrq_irq if
the data goes stale or to all Fs while that function is running?

Daniel

>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>  drivers/scsi/cxlflash/main.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index 24aedfb..ab11ee6 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -1598,6 +1598,9 @@ static int start_afu(struct cxlflash_cfg *cfg)
>  
>  	init_pcr(cfg);
>  
> +	/* After an AFU reset, RRQ entries are stale, clear them */
> +	memset(&afu->rrq_entry, 0, sizeof(afu->rrq_entry));
> +
>  	/* Initialize RRQ pointers */
>  	afu->hrrq_start = &afu->rrq_entry[0];
>  	afu->hrrq_end = &afu->rrq_entry[NUM_RRQ_ENTRY - 1];
> -- 
> 2.1.0
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJWCesgAAoJEPC3R3P2I92FE4kP+wYTEdCDP50RfKZPNCpoY//T
5tDNV58W1RasTrJLVGrpeGBboI4WTzRlKYAYX1iLC6ZSkX1rQS5rBqgImQQAg3i5
N9qoAdNCch06UVO7psceptT9653xt0OzitHW/tmB8pOMII65UIm8AtydSs2+J0e8
htw9Jnw098jls8NJtzz32T48QoM+kV1w7vfJJN36Z6FjL36KJLQCAL2/gLvv+3Zt
2ueeP6MM0q0iFxnQJwPFdf3DebggbMqeVbNorNAyCSkNNoUh2QR8NMHeFS8OoXCl
nrzjFoeSFDXh4c4bRzVoGRalIFzP+VY9guk9d/VtAt8ZkkrIyfI3K9lJTgDq2gqj
ShnT/WB4lskUVc/FjdkyIc+Nyg6pPkm4OftCnN7sf7CSd2+myO/d6S1f1qJlCn7s
3KBLXEFrKXKHl9TVDqkZSZVvyJOKmxoMqT98I00CWhXFkRgO126tnqsMsmrqgzxu
QxZQSo+/Oi7av6YuVtTP2c9SeYbGBfhOMOH5Dx7z9VY57rWvE5CVsduYJoG2D59P
Td5ToL1H3UOt8G1vzeqmkb7AWK882py2OLS7WG0PUDRDa2dfE6+8NOCJmuX9tW2x
/NnLlInDTiVTpz3iiJpe9Efu3SkL2KeMEBxi4jdt31hFO0BPeFWnZHKjwOa+uQ/w
OSaHCUZEZ6LRdbeJ1GLk
=O6Zk
-----END PGP SIGNATURE-----
