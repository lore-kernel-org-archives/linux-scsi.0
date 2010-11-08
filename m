From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 8/9] target: remove unused split_cdb_RW_* handlers
Date: Mon, 08 Nov 2010 14:41:28 -0800
Message-ID: <1289256088.27226.95.camel@haakon2.linux-iscsi.org>
References: <20101108155601.872926000@canuck.infradead.org>
	 <20101108155648.857647370@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43448 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab0KHWql (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 17:46:41 -0500
In-Reply-To: <20101108155648.857647370@canuck.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2010-11-08 at 10:56 -0500, Christoph Hellwig wrote:
> plain text document attachment (lio-cleanup-cdb-split)
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Commited as 4344aa17b7.  Thanks!

--nab

> Index: lio-core-2.6/drivers/target/target_core_scdb.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_scdb.c	2010-11-08 16:18:26.328196347 +0100
> +++ lio-core-2.6/drivers/target/target_core_scdb.c	2010-11-08 16:18:42.911529680 +0100
> @@ -51,16 +51,6 @@ void split_cdb_XX_6(
>  	cdb[4] = *sectors & 0xff;
>  }
>  
> -void split_cdb_RW_6(
> -	unsigned long long lba,
> -	u32 *sectors,
> -	unsigned char *cdb,
> -	int rw)
> -{
> -	cdb[0] = (rw) ? WRITE_6 : READ_6;
> -	split_cdb_XX_6(lba, sectors, &cdb[0]);
> -}
> -
>  /*	split_cdb_XX_10():
>   *
>   *	32-bit LBA w/ 16-bit SECTORS
> @@ -74,16 +64,6 @@ void split_cdb_XX_10(
>  	put_unaligned_be16(*sectors, &cdb[7]);
>  }
>  
> -void split_cdb_RW_10(
> -	unsigned long long lba,
> -	u32 *sectors,
> -	unsigned char *cdb,
> -	int rw)
> -{
> -	cdb[0] = (rw) ? WRITE_10 : READ_10;
> -	split_cdb_XX_10(lba, sectors, &cdb[0]);
> -}
> -
>  /*	split_cdb_XX_12():
>   *
>   *	32-bit LBA w/ 32-bit SECTORS
> @@ -97,16 +77,6 @@ void split_cdb_XX_12(
>  	put_unaligned_be32(*sectors, &cdb[6]);
>  }
>  
> -void split_cdb_RW_12(
> -	unsigned long long lba,
> -	u32 *sectors,
> -	unsigned char *cdb,
> -	int rw)
> -{
> -	cdb[0] = (rw) ? WRITE_12 : READ_12;
> -	split_cdb_XX_12(lba, sectors, &cdb[0]);
> -}
> -
>  /*	split_cdb_XX_16():
>   *
>   *	64-bit LBA w/ 32-bit SECTORS
> @@ -120,16 +90,6 @@ void split_cdb_XX_16(
>  	put_unaligned_be32(*sectors, &cdb[10]);
>  }
>  
> -void split_cdb_RW_16(
> -	unsigned long long lba,
> -	u32 *sectors,
> -	unsigned char *cdb,
> -	int rw)
> -{
> -	cdb[0] = (rw) ? WRITE_16 : READ_16;
> -	split_cdb_XX_16(lba, sectors, &cdb[0]);
> -}
> -
>  /*
>   *	split_cdb_XX_32():
>   *	
> @@ -143,16 +103,3 @@ void split_cdb_XX_32(
>  	put_unaligned_be64(lba, &cdb[12]);
>  	put_unaligned_be32(*sectors, &cdb[28]);
>  }
> -
> -void split_cdb_RW_32(
> -	unsigned long long lba,
> -	u32 *sectors,
> -	unsigned char *cdb,
> -	int rw)
> -{
> -	/*
> -	 * Set service action for VARIABLE_LENGTH_CMD
> -	 */
> -	cdb[9] = (rw) ? WRITE_32 : READ_32;
> -	split_cdb_XX_32(lba, sectors, &cdb[0]);	
> -}
> Index: lio-core-2.6/drivers/target/target_core_scdb.h
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_scdb.h	2010-11-08 16:18:52.318196349 +0100
> +++ lio-core-2.6/drivers/target/target_core_scdb.h	2010-11-08 16:18:57.131529680 +0100
> @@ -2,14 +2,9 @@
>  #define TARGET_CORE_SCDB_H
>  
>  extern void split_cdb_XX_6(unsigned long long, u32 *, unsigned char *);
> -extern void split_cdb_RW_6(unsigned long long, u32 *, unsigned char *, int);
>  extern void split_cdb_XX_10(unsigned long long, u32 *, unsigned char *);
> -extern void split_cdb_RW_10(unsigned long long, u32 *, unsigned char *, int);
>  extern void split_cdb_XX_12(unsigned long long, u32 *, unsigned char *);
> -extern void split_cdb_RW_12(unsigned long long, u32 *, unsigned char *, int);
>  extern void split_cdb_XX_16(unsigned long long, u32 *, unsigned char *);
> -extern void split_cdb_RW_16(unsigned long long, u32 *, unsigned char *, int);
>  extern void split_cdb_XX_32(unsigned long long, u32 *, unsigned char *);
> -extern void split_cdb_RW_32(unsigned long long, u32 *, unsigned char *, int);
>  
>  #endif /* TARGET_CORE_SCDB_H */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

