From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: [PATCH] sanitize ->bios_param prototype
Date: Sat, 26 Oct 2002 00:50:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021025225052.GA27927@win.tue.nl>
References: <20021025041735.A28857@lst.de> <200210251718.g9PHIpP03406@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210251718.g9PHIpP03406@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Fri, Oct 25, 2002 at 12:18:51PM -0500, James Bottomley wrote:

> Loading scsi_mod module
> /lib/scsi_mod.o: unresolved symbol __udivdi3
> 
> The problem seems to be the definition of sector_t for the division.  If I 
> make this fix:
> 
> ===== drivers/scsi/scsicam.c 1.10 vs edited =====
> --- 1.10/drivers/scsi/scsicam.c Thu Oct 24 19:29:22 2002
> +++ edited/drivers/scsi/scsicam.c       Fri Oct 25 12:10:40 2002
> @@ -80,11 +80,11 @@
>         if (ret || ip[0] > 255 || ip[1] > 63) {
>                 ip[0] = 64;
>                 ip[1] = 32;
> -               if ((capacity / (ip[0] * ip[1])) > 65534) {
> +               if (((unsigned long)capacity / (ip[0] * ip[1])) > 65534) {
>                         ip[0] = 255;
>                         ip[1] = 63;
>                 }
> -               ip[2] = capacity / (ip[0] * ip[1]);
> +               ip[2] = (unsigned long)capacity / (ip[0] * ip[1]);
>         }
>  
>         return 0;
> 
> Then everything works fine.  This is obviously not the correct fix, but it's 
> as good as the previous code, so it should be OK.

I didn't see hch's patch, but you can always write

	if (ret || ip[0] > 255 || ip[1] > 63) {
		ip[0] = 64;
		ip[1] = 32;
		if ((capacity >> 11) > 65534) {
			ip[0] = 255;
			ip[1] = 63;
		}
		if (capacity > 65535*63*255)
			ip[2] = 65535;
		else
			ip[2] = (unsigned long)capacity / (ip[0] * ip[1]);
	}

Andries


(ip[2] is returned in a short, so returning larger values is meaningless;
moreover, the current specification says that ip[2] is ignored)
