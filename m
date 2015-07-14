From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] aic7xxx: replace kmalloc/strcpy by kstrdup
Date: Tue, 14 Jul 2015 12:08:44 +0300
Message-ID: <20150714090844.GE4341@mwanda>
References: <4159f01e6450cee8093e7d6a0d979bbeab8243d0.1436858599.git.christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4159f01e6450cee8093e7d6a0d979bbeab8243d0.1436858599.git.christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: hare@suse.de, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 14, 2015 at 09:25:16AM +0200, Christophe JAILLET wrote:
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -1250,9 +1250,8 @@ ahd_linux_register_host(struct ahd_softc *ahd, struct scsi_host_template *templa
>  	ahd_set_unit(ahd, ahd_linux_unit++);
>  	ahd_unlock(ahd, &s);
>  	sprintf(buf, "scsi%d", host->host_no);
> -	new_name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
> +	new_name = kstrdup(buf, GFP_ATOMIC);
>  	if (new_name != NULL) {
> -		strcpy(new_name, buf);
>  		ahd_set_name(ahd, new_name);
>  	}

Remove the curly braces.  And below as well.

regards,
dan carpenter
