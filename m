From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged
Date: Mon, 6 Sep 2004 11:01:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040906110150.A4845@infradead.org>
References: <Pine.LNX.4.60.0409040033310.5266@poirot.grange> <20040904140102.A15247@infradead.org> <Pine.LNX.4.60.0409050022570.3092@poirot.grange> <20040904233835.A18659@infradead.org> <Pine.LNX.4.60.0409051654460.3039@poirot.grange> <1094398979.10977.9.camel@mulgrave> <20040905173134.A31521@infradead.org> <1094422949.10977.15.camel@mulgrave> <Pine.LNX.4.60.0409061042240.6252@poirot.grange> <Pine.LNX.4.60.0409061143020.8550@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:63750 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267538AbUIFKBy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Sep 2004 06:01:54 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0409061143020.8550@poirot.grange>; from g.liakhovetski@gmx.de on Mon, Sep 06, 2004 at 11:47:36AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Patch looks good to me.  Two hints for a possible followon patch:

> @@ -1552,15 +1520,11 @@
>  	    pDCB->Inquiry7 =3D ptr->Flags;
> =20
>  ckc_e:

Here we still have some INQUIRY snooping, and if you look how
ptr is set you'll see it'll OOPS for machines with more than 1GB of mem=
ory.

> -	dc390_updateDCB(pACB, pDCB);
> +	if (pDCB->DevMode & SYNC_NEGO_)
> +		pDCB->SyncMode |=3D SYNC_ENABLE;
> +	else {
> +		pDCB->SyncMode =3D 0;

pDCB is memset to 0 =E5t the start of the function, so the 0 initializa=
tion
here isn't nessecary strictly speaking.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
