From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH 08/10] scsi/trace: Use scsi_print_sense trace point
 instead of printk
Date: Wed, 27 Aug 2014 16:15:18 +0200
Message-ID: <53FDE7F6.5030308@suse.de>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <20140808115025.6768.70331.stgit@yuno-kbuild.novalocal>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140808115025.6768.70331.stgit@yuno-kbuild.novalocal>
Sender: linux-kernel-owner@vger.kernel.org
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 08/08/2014 01:50 PM, Yoshihiro YUNOMAE wrote:
> Previous sense messages can be mixed into other sense messages,
> because continuous printk (KERN_CONT) was used. To avoid the problem,
> patch d87f3a6f51 introduced a local buffer in Hannes's baranch (*1).
> But using local buffers can induce stack overflow, so we want to solv=
e the
> problem without local buffer if possible.
>
> trace_seq_printf can add log messages without local buffer, so we use=
 it.
>
> (*1) http://git.kernel.org/cgit/linux/kernel/git/hare/scsi-devel.git/=
log/?h=3Dlogging
>
> - Result examples
>
> <Before> (printk)
> sd 2:0:0:0: [sda] Sense Key : Medium Error [current]
>
> <After> (ftrace)
> scsi_print_sense: host_no=3D2 channel=3D0 id=3D0 lun=3D0 [sda] Sense =
Key (Medium Error [current])
>
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Doug Gilbert <dgilbert@interlog.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>   drivers/scsi/constants.c    |  145 ++------------------------------=
-----------
>   drivers/scsi/scsi_trace.c   |  140 ++++++++++++++++++++++++++++++++=
++++++++--
>   include/scsi/scsi_eh.h      |    7 ++
>   include/trace/events/scsi.h |   48 ++++++++++++++
>   4 files changed, 195 insertions(+), 145 deletions(-)
>
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index f7b7f32..85b75c8 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -19,7 +19,7 @@
>   #include <scsi/scsi_eh.h>
>   #include <scsi/scsi_dbg.h>
>
> -
> +#include <trace/events/scsi.h>
>
>   /* Commands with service actions that change the command name */
>   #define SERVICE_ACTION_IN_12 0xab
> @@ -1267,58 +1267,8 @@ static const struct error_info2 additional2[] =
=3D
>   	{0x70, 0x00, 0xff, "Decompression exception short algorithm id of =
%x"},
>   	{0, 0, 0, NULL}
>   };
> -
> -/* description of the sense key values */
> -static const char * const snstext[] =3D {
> -	"No Sense",	    /* 0: There is no sense information */
> -	"Recovered Error",  /* 1: The last command completed successfully
> -				  but used error correction */
> -	"Not Ready",	    /* 2: The addressed target is not ready */
> -	"Medium Error",	    /* 3: Data error detected on the medium */
> -	"Hardware Error",   /* 4: Controller or device failure */
> -	"Illegal Request",  /* 5: Error in request */
> -	"Unit Attention",   /* 6: Removable medium was changed, or
> -				  the target has been reset, or ... */
> -	"Data Protect",	    /* 7: Access to the data is blocked */
> -	"Blank Check",	    /* 8: Reached unexpected written or unwritten
> -				  region of the medium */
> -	"Vendor Specific(9)",
> -	"Copy Aborted",	    /* A: COPY or COMPARE was aborted */
> -	"Aborted Command",  /* B: The target aborted the command */
> -	"Equal",	    /* C: A SEARCH DATA command found data equal,
> -				  reserved in SPC-4 rev 36 */
> -	"Volume Overflow",  /* D: Medium full with still data to be written=
 */
> -	"Miscompare",	    /* E: Source data and data on the medium
> -				  do not agree */
> -	"Completed",	    /* F: command completed sense data reported,
> -				  may occur for successful command */
> -};
> -#else
> -static const char * const snstext[] =3D {
> -	"0x0", "0x1", "0x2", "0x3", "0x4", "0x5", "0x6", "0x7",
> -	"0x8", "0x9", "0xa", "0xb", "0xc", "0xd", "0xe", "0xf",
> -};
>   #endif
>
> -/* Get sense key string or NULL if not available */
> -const char *
> -scsi_sense_key_string(unsigned char key) {
> -	return snstext[key & 0xf];
> -}
> -EXPORT_SYMBOL(scsi_sense_key_string);
> -
> -const char *
> -scsi_sense_type_string(struct scsi_sense_hdr *sshdr)
> -{
> -	return scsi_sense_is_deferred(sshdr) ? "[deferred]" : "[current]";
> -}
> -
> -const char *
> -scsi_sense_format_string(struct scsi_sense_hdr *sshdr)
> -{
> -	return sshdr->response_code >=3D 0x72 ? "[descriptor]" : "";
> -}
> -
>   /*
>    * Get additional sense code string or NULL if not available.
>    * This string may contain a "%x" and should be printed with ascq a=
s arg.
> @@ -1375,105 +1325,22 @@ void
>   scsi_print_sense_hdr(struct scsi_device *sdev, const char *name,
>   		     struct scsi_sense_hdr *sshdr)
>   {
> -	sdev_printk(KERN_INFO, sdev, "[%s] Sense Key : %s %s%s\n", name,
> -		    scsi_sense_key_string(sshdr->sense_key),
> -		    scsi_sense_type_string(sshdr),
> -		    scsi_sense_format_string(sshdr));
> +	trace_scsi_print_sense(sdev, name, sshdr, NULL, 0, 0);
>   	scsi_show_extd_sense(sdev, name, sshdr->asc, sshdr->ascq);
>   }
>   EXPORT_SYMBOL(scsi_print_sense_hdr);
>
> -static void
> -scsi_dump_sense_buffer(struct scsi_device *sdev, const char *prefix,
> -		       const unsigned char *sense_buffer, int sense_len)
> -{
> -	char linebuf[128];
> -	int i, linelen, remaining;
> -
> -	if (sense_len < 32)
> -		sense_len =3D 32;
> -
> -	remaining =3D sense_len;
> -	for (i =3D 0; i < sense_len; i +=3D 16) {
> -		linelen =3D min(remaining, 16);
> -		remaining -=3D 16;
> -
> -		hex_dump_to_buffer(sense_buffer + i, linelen, 16, 1,
> -				   linebuf, sizeof(linebuf), false);
> -	}
> -	sdev_printk(KERN_INFO, sdev,
> -		    "[%s] Unrecognized sense data (in hex): %s",
> -		    prefix, linebuf);
> -}
> -
> -static void
> -scsi_decode_sense_extras(struct scsi_device *sdev, const char *name,
> -			 const unsigned char *sense_buffer, int sense_len)
> -{
> -	int res, sense_flags =3D 0, fixed_valid =3D 0;
> -	u64 info =3D 0;
> -	char buff[80];
> -	int blen;
> -
> -	if ((sense_buffer[0] & 0x80) < 0x72) {
> -		/* decode extras for "fixed" format */
> -		fixed_valid =3D sense_buffer[0] & 0x80;
> -		info =3D get_unaligned_be32(&sense_buffer[3]);
> -		sense_flags =3D sense_buffer[2];
> -	} else if (sense_buffer[7] > 0) {
> -		const u8 *ucp;
> -
> -		/* descriptor format with sense descriptors */
> -		ucp =3D scsi_sense_desc_find(sense_buffer, sense_len, 0);
> -		if (ucp) {
> -			fixed_valid =3D ucp[2] & 0x80;
> -			if (fixed_valid)
> -				info =3D get_unaligned_be64(&ucp[4]);
> -		}
> -		ucp =3D scsi_sense_desc_find(sense_buffer, sense_len, 4);
> -		if (ucp)
> -			sense_flags |=3D ucp[3] & 0xe0;
> -	}
> -
> -	if (!sense_flags && !fixed_valid)
> -		return;
> -
> -	res =3D 0;
> -	memset(buff, 0, sizeof(buff));
> -	blen =3D sizeof(buff) - 1;
> -	if (fixed_valid)
> -		res +=3D snprintf(buff + res, blen - res,
> -				"Info fld=3D0x%llx, ", info);
> -	if (sense_flags)
> -		res +=3D snprintf(buff + res, blen - res, "%s%s%s",
> -				sense_flags & SENSE_FMK ? "FMK, " : "",
> -				sense_flags & SENSE_EOM ? "EOM, " : "",
> -				sense_flags & SENSE_ILI ? "ILI, " : "");
> -	if (res) {
> -		res -=3D 2;
> -		buff[res] =3D '\0';
> -	}
> -
> -	sdev_printk(KERN_INFO, sdev, "[%s] %s\n", name, buff);
> -}
> -
>   /* Normalize and print sense buffer with name prefix */
>   void __scsi_print_sense(struct scsi_device *sdev, const char *name,
>   			const unsigned char *sense_buffer, int sense_len)
>   {
>   	struct scsi_sense_hdr sshdr;
> +	int raw;
>
> -	if (!scsi_normalize_sense(sense_buffer, sense_len, &sshdr)) {
> -		/* this may be SCSI-1 sense data */
> -		scsi_dump_sense_buffer(sdev, name, sense_buffer, sense_len);
> -		return;
> -	}
> +	raw =3D !scsi_normalize_sense(sense_buffer, sense_len, &sshdr);
>
> -	sdev_printk(KERN_INFO, sdev, "[%s] Sense Key : %s %s%s\n", name,
> -	       scsi_sense_key_string(sshdr.sense_key),
> -	       scsi_sense_type_string(&sshdr),
> -	       scsi_sense_format_string(&sshdr));
> -	scsi_decode_sense_extras(sdev, name, sense_buffer, sense_len);
> +	trace_scsi_print_sense(sdev, name, &sshdr, sense_buffer, sense_len,
> +			       raw);
>   	scsi_show_extd_sense(sdev, name, sshdr.asc, sshdr.ascq);
>   }
>   EXPORT_SYMBOL(__scsi_print_sense);
> diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
> index 6ffbc40..2ecb1dc 100644
> --- a/drivers/scsi/scsi_trace.c
> +++ b/drivers/scsi/scsi_trace.c
> @@ -17,15 +17,16 @@
>    */
>   #include <linux/kernel.h>
>   #include <linux/trace_seq.h>
> +#include <asm/unaligned.h>
>   #include <trace/events/scsi.h>
>
>   #include <scsi/scsi_dbg.h>
> +#include <scsi/scsi_eh.h>
>
>   #define SERVICE_ACTION16(cdb) (cdb[1] & 0x1f)
>   #define SERVICE_ACTION32(cdb) ((cdb[8] << 8) | cdb[9])
>
> -static const char *
> -scsi_trace_misc(struct trace_seq *, unsigned char *, int);
> +static const char *scsi_trace_misc(struct trace_seq *);
>
>   static const char *
>   scsi_trace_rw6(struct trace_seq *p, unsigned char *cdb, int len)
> @@ -242,12 +243,12 @@ scsi_trace_varlen(struct trace_seq *p, unsigned=
 char *cdb, int len)
>   	case WRITE_SAME_32:
>   		return scsi_trace_rw32(p, cdb, len);
>   	default:
> -		return scsi_trace_misc(p, cdb, len);
> +		return scsi_trace_misc(p);
>   	}
>   }
>
>   static const char *
> -scsi_trace_misc(struct trace_seq *p, unsigned char *cdb, int len)
> +scsi_trace_misc(struct trace_seq *p)
>   {
>   	const char *ret =3D p->buffer + p->len;
>
> @@ -285,10 +286,139 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsi=
gned char *cdb, int len)
>   	case VARIABLE_LENGTH_CMD:
>   		return scsi_trace_varlen(p, cdb, len);
>   	default:
> -		return scsi_trace_misc(p, cdb, len);
> +		return scsi_trace_misc(p);
>   	}
>   }
>
> +#ifdef CONFIG_SCSI_CONSTANTS
> +/* description of the sense key values */
> +static const char * const snstext[] =3D {
> +	"No Sense",	    /* 0: There is no sense information */
> +	"Recovered Error",  /* 1: The last command completed successfully
> +				  but used error correction */
> +	"Not Ready",	    /* 2: The addressed target is not ready */
> +	"Medium Error",	    /* 3: Data error detected on the medium */
> +	"Hardware Error",   /* 4: Controller or device failure */
> +	"Illegal Request",  /* 5: Error in request */
> +	"Unit Attention",   /* 6: Removable medium was changed, or
> +				  the target has been reset, or ... */
> +	"Data Protect",	    /* 7: Access to the data is blocked */
> +	"Blank Check",	    /* 8: Reached unexpected written or unwritten
> +				  region of the medium */
> +	"Vendor Specific(9)",
> +	"Copy Aborted",	    /* A: COPY or COMPARE was aborted */
> +	"Aborted Command",  /* B: The target aborted the command */
> +	"Equal",	    /* C: A SEARCH DATA command found data equal,
> +				  reserved in SPC-4 rev 36 */
> +	"Volume Overflow",  /* D: Medium full with still data to be written=
 */
> +	"Miscompare",	    /* E: Source data and data on the medium
> +				  do not agree */
> +	"Completed",	    /* F: command completed sense data reported,
> +				  may occur for successful command */
> +};
> +#else
> +static const char * const snstext[] =3D {
> +	"0x0", "0x1", "0x2", "0x3", "0x4", "0x5", "0x6", "0x7",
> +	"0x8", "0x9", "0xa", "0xb", "0xc", "0xd", "0xe", "0xf",
> +};
> +#endif
> +
> +/* Get sense key string or NULL if not available */
> +const char *
> +scsi_sense_key_string(unsigned char key) {
> +	return snstext[key & 0xf];
> +}
> +EXPORT_SYMBOL(scsi_sense_key_string);
> +
> +static const char *
> +scsi_sense_type_string(u8 res_code)
> +{
> +	return __scsi_sense_is_deferred(res_code) ? "[deferred]" : "[curren=
t]";
> +}
> +
> +static const char *
> +scsi_sense_format_string(u8 res_code)
> +{
> +	return res_code >=3D 0x72 ? "[descriptor]" : "";
> +}
> +
> +static const char *
> +scsi_dump_sense_buffer(struct trace_seq *p, const unsigned char *buf=
, int len)
> +{
> +	const char *ret =3D p->buffer + p->len;
> +	int i;
> +
> +	if (!buf || !len)
> +		return scsi_trace_misc(p);
> +
> +	if (len < 32)
> +		len =3D 32;
> +
> +	trace_seq_printf(p, "Unrecognized sense data (in hex)");
> +	for (i =3D 0; i < len; i +=3D 16)
> +		trace_seq_printf(p, " %02x", buf[i]);
> +
> +	trace_seq_putc(p, 0);
> +	return ret;
> +}
> +
> +const char *
> +scsi_trace_decode_sense_extras(struct trace_seq *p, u8 sense_key, u8=
 res_code,
> +			       const unsigned char *buf, int len, int raw)
> +{
> +	const char *ret =3D p->buffer + p->len;
> +	int sense_flags =3D 0, fixed_valid =3D 0;
> +	u64 info =3D 0;
> +
> +	if (raw)
> +		/* this may be SCSI-1 sense data */
> +		return scsi_dump_sense_buffer(p, buf, len);
> +
> +	trace_seq_printf(p, "Sense Key (%s %s%s",
> +			 scsi_sense_key_string(sense_key),
> +			 scsi_sense_type_string(res_code),
> +			 scsi_sense_format_string(res_code));
> +
> +	if (!buf || !len)
> +		goto out;
> +
> +	if ((buf[0] & 0x80) < 0x72) {
> +		/* decode extras for "fixed" format */
> +		fixed_valid =3D buf[0] & 0x80;
> +		info =3D get_unaligned_be32(&buf[3]);
> +		sense_flags =3D buf[2];
> +	} else if (buf[7] > 0) {
> +		const u8 *ucp;
> +
> +		/* descriptor format with sense descriptors */
> +		ucp =3D scsi_sense_desc_find(buf, len, 0);
> +		if (ucp) {
> +			fixed_valid =3D ucp[2] & 0x80;
> +			if (fixed_valid)
> +				info =3D get_unaligned_be64(&ucp[4]);
> +		}
> +		ucp =3D scsi_sense_desc_find(buf, len, 4);
> +		if (ucp)
> +			sense_flags |=3D ucp[3] & 0xe0;
> +	}
> +
> +	if (!sense_flags && !fixed_valid)
> +		goto out;
> +
> +	if (fixed_valid)
> +		trace_seq_printf(p, " Info fld=3D0x%llx", info);
> +	if (sense_flags)
> +		trace_seq_printf(p, " %s%s%s",
> +				sense_flags & SENSE_FMK ? "FMK" : "",
> +				sense_flags & SENSE_EOM ? "EOM" : "",
> +				sense_flags & SENSE_ILI ? "ILI" : "");
> +
> +out:
> +	trace_seq_printf(p, ")");
> +	trace_seq_putc(p, 0);
> +	return ret;
> +}
> +
>   void scsi_show_result(struct scsi_device *sdev, const char *name, i=
nt result)
>   {
>   	trace_scsi_show_result(sdev, name, result);
> diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
> index 06a8790..0e6d28c 100644
> --- a/include/scsi/scsi_eh.h
> +++ b/include/scsi/scsi_eh.h
> @@ -47,9 +47,14 @@ extern int scsi_normalize_sense(const u8 *sense_bu=
ffer, int sb_len,
>   extern int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
>   		struct scsi_sense_hdr *sshdr);
>
> +static inline int __scsi_sense_is_deferred(u8 response_code)
> +{
> +	return ((response_code >=3D 0x70) && (response_code & 1));
> +}
> +
>   static inline int scsi_sense_is_deferred(struct scsi_sense_hdr *ssh=
dr)
>   {
> -	return ((sshdr->response_code >=3D 0x70) && (sshdr->response_code &=
 1));
> +	return __scsi_sense_is_deferred(sshdr->response_code);
>   }
>
>   extern const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int=
 sb_len,
> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.=
h
> index 0675195..572aa65 100644
> --- a/include/trace/events/scsi.h
> +++ b/include/trace/events/scsi.h
> @@ -395,6 +395,54 @@ TRACE_EVENT(scsi_show_result,
>   		  show_hostbyte_name(host_byte(__entry->result)))
>   );
>
> +const char *scsi_trace_decode_sense_extras(struct trace_seq*, u8, u8=
,
> +					   const unsigned char*, int, int);
> +#define __decode_extras(sense_key, res_code, buf, len, raw) \
> +	scsi_trace_decode_sense_extras(p, sense_key, res_code, buf, len, ra=
w)
> +
> +TRACE_EVENT(scsi_print_sense,
> +
> +	TP_PROTO(struct scsi_device *sdev, const char *devname,
> +		 struct scsi_sense_hdr *sshdr,
> +		 const unsigned char *sense_buffer, int sense_len, int raw),
> +
> +	TP_ARGS(sdev, devname, sshdr, sense_buffer, sense_len, raw),
> +
> +	TP_STRUCT__entry(
> +		__field( unsigned int,		host_no		)
> +		__field( unsigned int,		channel		)
> +		__field( unsigned int,		id		)
> +		__field( unsigned int,		lun		)
> +		__string(devname,		devname		)
> +		__field( u8,			sense_key	)
> +		__field( u8,			res_code	)
> +		__dynamic_array(unsigned char,	sense_buffer, sense_len)
> +		__field( u8,			asc		)
> +		__field( u8,			ascq		)
> +		__field( int,			sense_len	)
> +		__field( int,			raw		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->host_no	=3D sdev->host->host_no;
> +		__entry->channel	=3D sdev->channel;
> +		__entry->id		=3D sdev->id;
> +		__entry->lun		=3D sdev->lun;
> +		__assign_str(devname, devname);
> +		__entry->sense_key	=3D sshdr->sense_key;
> +		__entry->res_code	=3D sshdr->response_code;
> +		memcpy(__get_dynamic_array(sense_buffer), sense_buffer,
> +		       sense_len);
> +		__entry->sense_len	=3D sense_len;
> +		__entry->raw		=3D raw;
> +	),
> +
> +	TP_printk("host_no=3D%u channel=3D%u id=3D%u lun=3D%u [%s] %s",
> +		  __entry->host_no, __entry->channel, __entry->id, __entry->lun,
> +		  __get_str(devname), __decode_extras(__entry->sense_key,
> +		  __entry->res_code, __get_dynamic_array(sense_buffer),
> +		  __entry->sense_len,  __entry->raw))
> +);
>   #endif /*  _TRACE_SCSI_H */
>
>   /* This part must be outside protection */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Same here:
Please use the functions from constants.c and delete the=20
functionality from scsi_trace.

And we should remove the code to interpret any sense code extras.
But other than that having trace points for sense code printing is a=20
really good idea.
Care to send this as a separate patch?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
