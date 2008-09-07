From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/3] 24-bit types: typedef and macros for accessing 3-byte
 arrays as integers
Date: Sun, 07 Sep 2008 12:36:41 +0300
Message-ID: <48C3A0A9.3000206@panasas.com>
References: <20080905165732.16689.50256.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:14469 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750871AbYIGJhH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2008 05:37:07 -0400
In-Reply-To: <20080905165732.16689.50256.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Leech <christopher.leech@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devel@open-fcoe.org, Harvey Harrison <harvey.harrison@gmail.com>

Chris Leech wrote:
> Both iSCSI and Fibre Channel make use of 24-bit big-endian values in
> frame headers.  This patch defines __be24 and __le24 typedefs for a
> structure wrapped around a 3-byte array, and macros to convert back and
> forth to a 32-bit integer.
> 
> The undefs in iscsi_proto.h are because of the different calling
> convention for the existing hton24 macro in the iSCSI code.  iSCSI will
> be converted in a subsequent patch.
> 
> Signed-off-by: Chris Leech <christopher.leech@intel.com>

I like what this patch wants to accomplish, but I disagree with the
implementation.

First why is the double definition, one in include/linux/byteorder.h
and one in include/linux/byteorder/generic.h ?

Second and most important, in both these files all routines are inline's
not MACROs, and rightly so. There is no place for a macro and the MACRO
works bad for these. One - the definition of a local variable in a {} scope
in the middle of anywhere. Second - type safety.

I CC: Harvey Harrison which did lots of work in these area's.

For me this patch is totally unacceptable.

Thanks for working on this
Boaz
> ---
> 
>  include/linux/byteorder.h         |   56 ++++++++++++++++++++++++++++++++++++
>  include/linux/byteorder/generic.h |   57 +++++++++++++++++++++++++++++++++++++
>  include/linux/types.h             |    2 +
>  include/scsi/iscsi_proto.h        |    2 +
>  4 files changed, 117 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/include/linux/byteorder.h b/include/linux/byteorder.h
> index 29f002d..e41c17b 100644
> --- a/include/linux/byteorder.h
> +++ b/include/linux/byteorder.h
> @@ -62,6 +62,54 @@
>  # define __cpu_to_le64(x) ((__force __le64)__swab64(x))
>  #endif
>  
> +/**
> + * __le24_to_cpu - read a 3-byte array as a 24-bit little-endian integer
> + * @x: __le24, a structure wrapper around a 3-byte array
> + *
> + * Evaluates to a __u32 integer type
> + */
> +#define __le24_to_cpu(x) \
> +({ \
> +	__le24 _x = (x); \
> +	(__u32) ((_x.b[2] << 16) | (_x.b[1] << 8) | (_x.b[0])); \
> +})
> +
> +/**
> + * __cpu_to_le24 - store a value in a 3-byte array in little-endian format
> + * @x: __u32, there is no checking to ensure only the lower 24 bits are set
> + *
> + * Evaluates to an __le24 compound literal
> + */
> +#define __cpu_to_le24(x) \
> +({ \
> +	__u32 _x = (x); \
> +	(__le24) { .b = { _x & 0xff, (_x >> 8) & 0xff, (_x >> 16) & 0xff } }; \
> +})
> +
> +/**
> + * __be24_to_cpu - read a 3-byte array as a 24-bit big-endian integer
> + * @x: __be24, a structure wrapper around a 3-byte array
> + *
> + * Evaluates to a __u32 integer type
> + */
> +#define __be24_to_cpu(x) \
> +({ \
> +	__be24 _x = (x); \
> +	(__u32) ((_x.b[0] << 16) | (_x.b[1] << 8) | (_x.b[2])); \
> +})
> +
> +/**
> + * __cpu_to_be24 - store a value in a 3-byte array in big-endian format
> + * @x: __u32, there is no checking to ensure only the lower 24 bits are set
> + *
> + * Evaluates to an __be24 compound literal
> + */
> +#define __cpu_to_be24(x) \
> +({ \
> +	__u32 _x = (x); \
> +	(__be24) { .b = { (_x >> 16) & 0xff, (_x >> 8) & 0xff, _x & 0xff } }; \
> +})
> +
>  /*
>   * These helpers could be phased out over time as the base version
>   * handles constant folding.
> @@ -280,15 +328,19 @@ static inline __be64 __cpu_to_be64p(const __u64 *p)
>  #ifdef __KERNEL__
>  
>  # define le16_to_cpu __le16_to_cpu
> +# define le24_to_cpu __le24_to_cpu
>  # define le32_to_cpu __le32_to_cpu
>  # define le64_to_cpu __le64_to_cpu
>  # define be16_to_cpu __be16_to_cpu
> +# define be24_to_cpu __be24_to_cpu
>  # define be32_to_cpu __be32_to_cpu
>  # define be64_to_cpu __be64_to_cpu
>  # define cpu_to_le16 __cpu_to_le16
> +# define cpu_to_le24 __cpu_to_le24
>  # define cpu_to_le32 __cpu_to_le32
>  # define cpu_to_le64 __cpu_to_le64
>  # define cpu_to_be16 __cpu_to_be16
> +# define cpu_to_be24 __cpu_to_be24
>  # define cpu_to_be32 __cpu_to_be32
>  # define cpu_to_be64 __cpu_to_be64
>  
> @@ -332,11 +384,15 @@ static inline __be64 __cpu_to_be64p(const __u64 *p)
>  # define ___htons(x) __cpu_to_be16(x)
>  # define ___ntohl(x) __be32_to_cpu(x)
>  # define ___ntohs(x) __be16_to_cpu(x)
> +# define ___hton24(x) __cpu_to_be24(x)
> +# define ___ntoh24(x) __be24_to_cpu(x)
>  
>  # define htonl(x) ___htonl(x)
>  # define ntohl(x) ___ntohl(x)
>  # define htons(x) ___htons(x)
>  # define ntohs(x) ___ntohs(x)
> +# define hton24(x) ___hton24(x)
> +# define ntoh24(x) ___ntoh24(x)
>  
>  static inline void le16_add_cpu(__le16 *var, u16 val)
>  {
> diff --git a/include/linux/byteorder/generic.h b/include/linux/byteorder/generic.h
> index 0846e6b..a57fbc3 100644
> --- a/include/linux/byteorder/generic.h
> +++ b/include/linux/byteorder/generic.h
> @@ -119,6 +119,59 @@
>  #define cpu_to_be16s __cpu_to_be16s
>  #define be16_to_cpus __be16_to_cpus
>  
> +/**
> + * __le24_to_cpu - read a 3-byte array as a 24-bit little-endian integer
> + * @x: __le24, a structure wrapper around a 3-byte array
> + *
> + * Evaluates to a __u32 integer type
> + */
> +#define __le24_to_cpu(x) \
> +({ \
> +	__le24 _x = (x); \
> +	(__u32) ((_x.b[2] << 16) | (_x.b[1] << 8) | (_x.b[0])); \
> +})
> +
> +/**
> + * __cpu_to_le24 - store a value in a 3-byte array in little-endian format
> + * @x: __u32, there is no checking to ensure only the lower 24 bits are set
> + *
> + * Evaluates to an __le24 compound literal
> + */
> +#define __cpu_to_le24(x) \
> +({ \
> +	__u32 _x = (x); \
> +	(__le24) { .b = { _x & 0xff, (_x >> 8) & 0xff, (_x >> 16) & 0xff } }; \
> +})
> +
> +/**
> + * __be24_to_cpu - read a 3-byte array as a 24-bit big-endian integer
> + * @x: __be24, a structure wrapper around a 3-byte array
> + *
> + * Evaluates to a __u32 integer type
> + */
> +#define __be24_to_cpu(x) \
> +({ \
> +	__be24 _x = (x); \
> +	(__u32) ((_x.b[0] << 16) | (_x.b[1] << 8) | (_x.b[2])); \
> +})
> +
> +/**
> + * __cpu_to_be24 - store a value in a 3-byte array in big-endian format
> + * @x: __u32, there is no checking to ensure only the lower 24 bits are set
> + *
> + * Evaluates to an __be24 compound literal
> + */
> +#define __cpu_to_be24(x) \
> +({ \
> +	__u32 _x = (x); \
> +	(__be24) { .b = { (_x >> 16) & 0xff, (_x >> 8) & 0xff, _x & 0xff } }; \
> +})
> +
> +#define le24_to_cpu __le24_to_cpu
> +#define cpu_to_le24 __cpu_to_le24
> +#define be24_to_cpu __be24_to_cpu
> +#define cpu_to_be24 __cpu_to_be24
> +
>  /*
>   * They have to be macros in order to do the constant folding
>   * correctly - if the argument passed into a inline function
> @@ -134,11 +187,15 @@
>  #define ___htons(x) __cpu_to_be16(x)
>  #define ___ntohl(x) __be32_to_cpu(x)
>  #define ___ntohs(x) __be16_to_cpu(x)
> +#define ___hton24(x) __cpu_to_be24(x)
> +#define ___ntoh24(x) __be24_to_cpu(x)
>  
>  #define htonl(x) ___htonl(x)
>  #define ntohl(x) ___ntohl(x)
>  #define htons(x) ___htons(x)
>  #define ntohs(x) ___ntohs(x)
> +#define hton24(x) ___hton24(x)
> +#define ntoh24(x) ___ntoh24(x)
>  
>  static inline void le16_add_cpu(__le16 *var, u16 val)
>  {
> diff --git a/include/linux/types.h b/include/linux/types.h
> index d4a9ce6..85fcff7 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -188,6 +188,8 @@ typedef __u64 __bitwise __be64;
>  typedef __u16 __bitwise __sum16;
>  typedef __u32 __bitwise __wsum;
>  
> +typedef struct { __u8 b[3]; } __be24, __le24;
> +
>  #ifdef __KERNEL__
>  typedef unsigned __bitwise__ gfp_t;
>  
> diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
> index f2a2c11..429c5ff 100644
> --- a/include/scsi/iscsi_proto.h
> +++ b/include/scsi/iscsi_proto.h
> @@ -35,6 +35,8 @@
>  /*
>   * useful common(control and data pathes) macro
>   */
> +#undef ntoh24
> +#undef hton24
>  #define ntoh24(p) (((p)[0] << 16) | ((p)[1] << 8) | ((p)[2]))
>  #define hton24(p, v) { \
>          p[0] = (((v) >> 16) & 0xFF); \
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

