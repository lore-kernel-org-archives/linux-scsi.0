From: Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>
Subject: Re: AS2105-based enclosure size issues with >2TB HDDs
Date: Mon, 25 Aug 2014 15:16:58 +0200
Message-ID: <1408972618.10300.35.camel@linux-fkkt.site>
References: <87801b450dee41dda169a3aa2dd2baf6@serv030.corp.eldorado.org.br>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87801b450dee41dda169a3aa2dd2baf6-CWPHn/M7kmRpAIlDVkCwMZnVvqcnFG0x9MRKq5+/VYY@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alfredo Dal Ava Junior <alfredo.junior-peCLlicIkyA3OWu3QmcX+g@public.gmane.org>
Cc: "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2014-08-25 at 10:58 +0000, Alfredo Dal Ava Junior wrote:

> - 1TB and 2TB: READ_CAPACITY_10 returns correct size value
> - 3TB and 4TB: READ_CAPACITY_10 returns size in a 2TB modulus
> 
> If we fix capacity size by reporting (READ_CAPACITY_10 + MODULO_2TB), the result
>  will be invalid when user plugs a <2TB HDD. An idea (bring by Oliver) is:

It is worse than that. Pretty soon a 4.7TB disk will also be plausible.

> first guess reading last sector using modulus result to check if size is valid.

It is necessary that a virgin disk also be handled correctly.
We cannot use the partition table (besides it being a layering
violation)

It would propose (in pseudo code)

if (read_capacity_16(device) < 0) {
	lower_limit = read_capacity_10(device);
	for (i = 1; i++; i < SANITY_LIMIT) {
		err = read_sector(device, lower_limit + i * 2TB-SAFETY);
		if (err == OUT_OF_RANGE)
			break;
	}
	if (i < SANITY_LIMIT)
		return (i - 1) * 2TB + lower_limit;
	else
		return ERROR;

	Regards
		Oliver


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
