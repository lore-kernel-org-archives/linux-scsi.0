From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 05/10] iser: Have initiator and target to share
 protocol structures and definitions
Date: Thu, 19 Nov 2015 09:20:21 +0200
Message-ID: <564D7835.4010407@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-6-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447691861-3796-6-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 11/16/2015 6:37 PM, Sagi Grimberg wrote:
> +/**
> + * struct iser_hello - iSER Hello header
> + *
> + * @opcode:       opcode (must be set to ISER_HELLO)
> + * @max_min_ver:  maximum and minimum iser versions
> + * @iser_ird:     iSER IRD
> + * @rsvd:         reserved
> + */
> +struct iser_hello {
> +	u8      opcode;
> +	u8	max_min_ver;
> +	u16	iser_ird;
> +	u8	rsvd[20];
> +} __packed;
> +
> +/**
> + * struct iser_hello_rep - iSER Hello reply header
> + *
> + * @opcode_rej:   opcode (must be set to ISER_HELLORPLY)
> + *                lower bit is reject bit
> + * @max_cur_ver:  maximum and current iser versions
> + * @iser_ord:     iSER ORD
> + * @rsvd:         reserved
> + */
> +struct iser_hello_rep {
> +	u8      opcode_rej;
> +	u8	max_cur_ver;
> +	u16	iser_ord;
> +	u8	rsvd[20];
> +} __packed;
> +

I don't see the point to include these two defs, we don't use them and 
Steve even got iser to work
over iwarp without them, so why care? we should only leave
>
> +#define ISER_HELLO	0x20
> +#define ISER_HELLORPLY	0x30
to allow warnings on them if we get such packets
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
