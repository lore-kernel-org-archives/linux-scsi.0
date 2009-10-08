From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH 5/14] bfa: Brocade BFA FC SCSI driver (bfa4)
Date: Thu, 08 Oct 2009 12:39:21 -0400
Message-ID: <4ACE15B9.1060501@redhat.com>
References: <200909240055.n8O0tNHN016016@swe58.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758892AbZJHQqE@vger.kernel.org>
In-Reply-To: <200909240055.n8O0tNHN016016@swe58.brocade.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com
List-Id: linux-scsi@vger.kernel.org


> +
> +#define bfa_swap_3b(_x)				\
> +	((((_x) & 0xff) << 16) |		\
> +	((_x) & 0x00ff00) |			\
> +	(((_x) & 0xff0000) >> 16))
> +
> +#define bfa_swap_8b(_x) 				\
> +     ((((_x) & 0xff00000000000000ull) >> 56)		\
> +      | (((_x) & 0x00ff000000000000ull) >> 40)		\
> +      | (((_x) & 0x0000ff0000000000ull) >> 24)		\
> +      | (((_x) & 0x000000ff00000000ull) >> 8)		\
> +      | (((_x) & 0x00000000ff000000ull) << 8)		\
> +      | (((_x) & 0x0000000000ff0000ull) << 24)		\
> +      | (((_x) & 0x000000000000ff00ull) << 40)		\
> +      | (((_x) & 0x00000000000000ffull) << 56))
> +
> +#define bfa_os_swap32(_x) 			\
> +	((((_x) & 0xff) << 24) 		|	\
> +	(((_x) & 0x0000ff00) << 8)	|	\
> +	(((_x) & 0x00ff0000) >> 8)	|	\
> +	(((_x) & 0xff000000) >> 24))
> +
> +
> +#ifndef __BIGENDIAN
> +#define bfa_os_htons(_x) ((u16)((((_x) & 0xff00) >> 8) | \
> +				 (((_x) & 0x00ff) << 8)))
> +
> +#define bfa_os_htonl(_x)	bfa_os_swap32(_x)
> +#define bfa_os_htonll(_x)	bfa_swap_8b(_x)
> +#define bfa_os_hton3b(_x)	bfa_swap_3b(_x)
> +
> +#define bfa_os_wtole(_x)   (_x)
> +
> +#else
> +
> +#define bfa_os_htons(_x)   (_x)
> +#define bfa_os_htonl(_x)   (_x)
> +#define bfa_os_hton3b(_x)  (_x)
> +#define bfa_os_htonll(_x)  (_x)
> +#define bfa_os_wtole(_x)   bfa_os_swap32(_x)
> +
> +#endif
> +
> +#define bfa_os_ntohs(_x)   bfa_os_htons(_x)
> +#define bfa_os_ntohl(_x)   bfa_os_htonl(_x)
> +#define bfa_os_ntohll(_x)  bfa_os_htonll(_x)
> +#define bfa_os_ntoh3b(_x)  bfa_os_hton3b(_x)
>   

Can bfa_os_ntoh* and bfa_os_hton* be defined to use
linux defined ntoh* and hton*?

include/linux/byteorder/generic.h has some of these definitions.
Perhaps this could be expanded a bit, or, is an expanded set
of such definitions available elsewhere?
