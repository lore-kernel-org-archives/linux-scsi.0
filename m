From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 17/32] cxlflash: Remove dual port online dependency
Date: Tue, 29 Sep 2015 09:37:31 +1000
Message-ID: <87a8s6und0.fsf@gamma.ozlabs.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443223018-9577-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36649 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbbI1Xhp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2015 19:37:45 -0400
Received: by pablk4 with SMTP id lk4so90212844pab.3
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2015 16:37:44 -0700 (PDT)
In-Reply-To: <1443223018-9577-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi,

>  static int afu_set_wwpn(struct afu *afu, int port, u64 *fc_regs, u64 wwpn)
>  {
> -	int ret = 0;
> +	int rc = 0;
I realise it's nice to have things consistent, but making this change
now makes the rest of the patch quite difficult to follow.

>  
>  	set_port_offline(fc_regs);
>  
> @@ -1038,33 +1038,26 @@ static int afu_set_wwpn(struct afu *afu, int port, u64 *fc_regs, u64 wwpn)
>  			       FC_PORT_STATUS_RETRY_CNT)) {
>  		pr_debug("%s: wait on port %d to go offline timed out\n",
>  			 __func__, port);
> -		ret = -1; /* but continue on to leave the port back online */
> +		rc = -1; /* but continue on to leave the port back online */
>  	}
>  
> -	if (ret == 0)
> +	if (rc == 0)
>  		writeq_be(wwpn, &fc_regs[FC_PNAME / 8]);
>  
> +	/* Always return success after programming WWPN */
> +	rc = 0;
> +
>  	set_port_online(fc_regs);
>  
>  	if (!wait_port_online(fc_regs, FC_PORT_STATUS_RETRY_INTERVAL_US,
>  			      FC_PORT_STATUS_RETRY_CNT)) {
>  		pr_debug("%s: wait on port %d to go online timed out\n",
>  			 __func__, port);
> -		ret = -1;
> -
> -		/*
> -		 * Override for internal lun!!!
> -		 */
> -		if (afu->internal_lun) {
> -			pr_debug("%s: Overriding port %d online timeout!!!\n",
> -				 __func__, port);
> -			ret = 0;
> -		}
>  	}
>  
> -	pr_debug("%s: returning rc=%d\n", __func__, ret);
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
I'm not sure I fully understand the flow of this function, but it looks
like you set rc=0 regardless of how things actually go: is this ever
going to print a return value other than zero?

Regards,
Daniel
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJWCc87AAoJEPC3R3P2I92FQNcP/RF+M8MGZ2PJ8heh98D84rb5
Dx+Yq1czRJ+YZbK5tCfkyU66KspEzM7IIOiiXDLlBZ+AjcQtCUopTNMbL/UN+oVT
5lWrvPZlWRJqRN5bA/RA3i/DSBRucucmP8n4pmTKqsMMqKwzk/f3sE+Uo5oAzS+y
JaSywxm+Vd4dkW5T94kc6TXCeWcaD47tG0mgg0jHGwFtOioDEeWgf7Kie52+RV+o
I6z7GlQj9dgcKs2NmVr67AoY1dfRYl1ZvvJN7bYoLbHnEgiSw1d6XZK/2cqHzIpE
S1KEHOyuSZJh8Txwfg6oJ3sbpFZaurSIXDXfOhWuJ90OrOu4hgeODTPX/3o2CKae
K+WhsL6XOhrxyMhfq/VWplF6Hjo7VqLcT9e0sYZ4YNkUJrGAza3iPOqngK9zmdsM
80HLJdbsiZMkl+i55IOuisckCtvjUtVE+bDlzau6vwgBlgZ9DKByPPmqJGjS9I3L
vCEKsRZryaSvaYSnK46kpqXsukN/+QMefXL25IfTf4wQQaV4O+mSJxkkLXPAKqfd
cvCFg08MyAQS+YyNMBdFDJyj7tWVclGZhJkqlyjPjQ2YrFA5tQ7MoqY05NomxY9Q
xo0JuaceNccFetKPg1LMmTp5Ag/2DCcnGq/0Z3ioGVJTFIVil0BnWIFctlGbquya
n4Ylfe3h1T6hWJ7bjxwF
=cZRI
-----END PGP SIGNATURE-----
