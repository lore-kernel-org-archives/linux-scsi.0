From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/3] 24-bit types: typedef and macros for	accessing	3-byte
 arrays as integers
Date: Wed, 10 Sep 2008 19:11:09 +0300
Message-ID: <48C7F19D.3080507@panasas.com>
References: <20080905165732.16689.50256.stgit@localhost.localdomain>	 <20080910140712.GA12280@infradead.org> <1221061241.27385.14.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:18424 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752149AbYIJQQz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2008 12:16:55 -0400
In-Reply-To: <1221061241.27385.14.camel@norville.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Leech <christopher.leech@intel.com>, jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devel@open-fcoe.org

Dave Kleikamp wrote:
> On Wed, 2008-09-10 at 10:07 -0400, Christoph Hellwig wrote:
> 
>> JFS already defines an __le24, see fs/jfs/endian24.h.  Please try to
>> cover it, too or at least make sure you don't break it.
> 
> Chris,
> This patch takes care of jfs.  Please add it to your patchset.
> 
> Thanks,
> Shaggy
> 
> 24-bit types: Convert jfs to use the common 24-bit types
> 
> This patch cleans up some of the ugliness in the jfs headers and
> uses the common 24-bit types instead of its private definitions.
> 
> Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> 
> diff --git a/fs/jfs/endian24.h b/fs/jfs/endian24.h
> deleted file mode 100644
> index fa92f7f..0000000
> --- a/fs/jfs/endian24.h
> +++ /dev/null
> @@ -1,49 +0,0 @@
> -/*
> - *   Copyright (C) International Business Machines Corp., 2001
> - *
> - *   This program is free software;  you can redistribute it and/or modify
> - *   it under the terms of the GNU General Public License as published by
> - *   the Free Software Foundation; either version 2 of the License, or
> - *   (at your option) any later version.
> - *
> - *   This program is distributed in the hope that it will be useful,
> - *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
> - *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
> - *   the GNU General Public License for more details.
> - *
> - *   You should have received a copy of the GNU General Public License
> - *   along with this program;  if not, write to the Free Software
> - *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> - */
> -#ifndef _H_ENDIAN24
> -#define	_H_ENDIAN24
> -
> -/*
> - *	endian24.h:
> - *
> - * Endian conversion for 24-byte data
> - *
> - */
> -#define __swab24(x) \
> -({ \
> -	__u32 __x = (x); \
> -	((__u32)( \
> -		((__x & (__u32)0x000000ffUL) << 16) | \
> -		 (__x & (__u32)0x0000ff00UL)	    | \
> -		((__x & (__u32)0x00ff0000UL) >> 16) )); \
> -})
> -
> -#if (defined(__KERNEL__) && defined(__LITTLE_ENDIAN)) || (defined(__BYTE_ORDER) && (__BYTE_ORDER == __LITTLE_ENDIAN))
> -	#define __cpu_to_le24(x) ((__u32)(x))
> -	#define __le24_to_cpu(x) ((__u32)(x))
> -#else
> -	#define __cpu_to_le24(x) __swab24(x)
> -	#define __le24_to_cpu(x) __swab24(x)
> -#endif
> -
> -#ifdef __KERNEL__
> -	#define cpu_to_le24 __cpu_to_le24
> -	#define le24_to_cpu __le24_to_cpu
> -#endif
> -
> -#endif				/* !_H_ENDIAN24 */
> diff --git a/fs/jfs/jfs_types.h b/fs/jfs/jfs_types.h
> index 649f981..6c49b93 100644
> --- a/fs/jfs/jfs_types.h
> +++ b/fs/jfs/jfs_types.h
> @@ -30,8 +30,6 @@
>  #include <linux/types.h>
>  #include <linux/nls.h>
>  
> -#include "endian24.h"
> -
>  /*
>   * transaction and lock id's
>   *
> @@ -62,7 +60,7 @@ struct timestruc_t {
>   */
>  typedef struct {
>  	unsigned len:24;
> -	unsigned off1:8;
> +	u8 off1;
>  	u32 off2;
>  } lxd_t;
>  

Why is the difference from below definition. That is the
use/not of __le24? 

> @@ -90,8 +88,8 @@ struct lxdlist {
>   *	physical xd (pxd)
>   */
>  typedef struct {
> -	unsigned len:24;
> -	unsigned addr1:8;
> +	__le24 len;

Is this stuff on-the-wire?
Do you need a:
+	__le24 len __packed;

> +	u8 addr1;
>  	__le32 addr2;
>  } pxd_t;
and:
  } pxd_t __packed ;

>  
> @@ -122,13 +120,13 @@ struct pxdlist {
>   *	data extent descriptor (dxd)
>   */
>  typedef struct {
> -	unsigned flag:8;	/* 1: flags */
> -	unsigned rsrvd:24;
> -	__le32 size;		/* 4: size in byte */
> -	unsigned len:24;	/* 3: length in unit of fsblksize */
> -	unsigned addr1:8;	/* 1: address in unit of fsblksize */
> -	__le32 addr2;		/* 4: address in unit of fsblksize */
> -} dxd_t;			/* - 16 - */
> +	u8 flag;	/* 1: flags */
> +	u8 rsrvd[3];
> +	__le32 size;	/* 4: size in byte */
> +	__le24 len;	/* 3: length in unit of fsblksize */
> +	u8 addr1;	/* 1: address in unit of fsblksize */
> +	__le32 addr2;	/* 4: address in unit of fsblksize */
> +} dxd_t;		/* - 16 - */
>  
>  /* dxd_t flags */
>  #define	DXD_INDEX	0x80	/* B+-tree index */
> diff --git a/fs/jfs/jfs_xtree.h b/fs/jfs/jfs_xtree.h
> index 70815c8..92beff3 100644
> --- a/fs/jfs/jfs_xtree.h
> +++ b/fs/jfs/jfs_xtree.h
> @@ -29,14 +29,14 @@
>   *	extent allocation descriptor (xad)
>   */
>  typedef struct xad {
> -	unsigned flag:8;	/* 1: flag */
> -	unsigned rsvrd:16;	/* 2: reserved */
> -	unsigned off1:8;	/* 1: offset in unit of fsblksize */
> -	__le32 off2;		/* 4: offset in unit of fsblksize */
> -	unsigned len:24;	/* 3: length in unit of fsblksize */
> -	unsigned addr1:8;	/* 1: address in unit of fsblksize */
> -	__le32 addr2;		/* 4: address in unit of fsblksize */
> -} xad_t;			/* (16) */
> +	u8 flag;	/* 1: flag */
> +	u8 rsvrd[2];	/* 2: reserved */
> +	u8 off1;	/* 1: offset in unit of fsblksize */
> +	__le32 off2;	/* 4: offset in unit of fsblksize */
> +	__le24 len;	/* 3: length in unit of fsblksize */
> +	u8 addr1;	/* 1: address in unit of fsblksize */
> +	__le32 addr2;	/* 4: address in unit of fsblksize */
> +} xad_t;		/* (16) */
>  
>  #define MAXXLEN		((1 << 24) - 1)
>  
> 

Note that before the :24 bit-field was kept packed but now
with the use of struct at the __le24 definition it might
choose to pad them.

Chris you might want to change the definitions at linux/types.h
to:

typedef struct { __u8 b[3]; } __be24, __le24 __packed;

With gcc it will not help with the proceeding fields, and the
containing struct will need it's own "__packed" declaration
but it will keep it packed with previous fields.

Just my $0.017
Boaz
