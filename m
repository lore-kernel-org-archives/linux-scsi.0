From: Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [PATCH] scsi: use __uX types for headers exported to user space
Date: Thu, 17 Dec 2009 12:58:24 +0100
Message-ID: <87zl5h4xsv.fsf@macbook.be.48ers.dk>
References: <1259317748-27167-1-git-send-email-jacmet@sunsite.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35307 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbZLQL6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2009 06:58:30 -0500
Received: by ewy19 with SMTP id 19so317040ewy.21
        for <linux-scsi@vger.kernel.org>; Thu, 17 Dec 2009 03:58:28 -0800 (PST)
In-Reply-To: <1259317748-27167-1-git-send-email-jacmet@sunsite.dk> (Peter
	Korsgaard's message of "Fri, 27 Nov 2009 11:29:08 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: james.smart@emulex.com, linux-scsi@vger.kernel.org

>>>>> "Peter" =3D=3D Peter Korsgaard <jacmet@sunsite.dk> writes:

 Peter> Commit 9e4f5e29 (FC Pass Thru support) exported a number of hea=
der files
 Peter> in include/scsi to user space, but didn't change the uX types t=
o the
 Peter> userspace-compatible __uX types. Without that you'll get compil=
e errors
 Peter> when including them - E.G.:

 Peter> /tmp/include/scsi/scsi.h:145: error: expected specifier-qualifi=
er-list
 Peter> before =E2=80=98u8=E2=80=99

Still no feedback?


 Peter> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
 Peter> ---
 Peter>  include/scsi/scsi.h         |    8 ++++----
 Peter>  include/scsi/scsi_netlink.h |   20 ++++++++++----------
 Peter>  2 files changed, 14 insertions(+), 14 deletions(-)

 Peter> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
 Peter> index 34c46ab..b3cffec 100644
 Peter> --- a/include/scsi/scsi.h
 Peter> +++ b/include/scsi/scsi.h
 Peter> @@ -145,10 +145,10 @@ struct scsi_cmnd;
=20
 Peter>  /* defined in T10 SCSI Primary Commands-2 (SPC2) */
 Peter>  struct scsi_varlen_cdb_hdr {
 Peter> -	u8 opcode;        /* opcode always =3D=3D VARIABLE_LENGTH_CMD=
 */
 Peter> -	u8 control;
 Peter> -	u8 misc[5];
 Peter> -	u8 additional_cdb_length;         /* total cdb length - 8 */
 Peter> +	__u8 opcode;        /* opcode always =3D=3D VARIABLE_LENGTH_C=
MD */
 Peter> +	__u8 control;
 Peter> +	__u8 misc[5];
 Peter> +	__u8 additional_cdb_length;         /* total cdb length - 8 *=
/
 Peter>  	__be16 service_action;
 Peter>  	/* service specific data follows */
 Peter>  };
 Peter> diff --git a/include/scsi/scsi_netlink.h b/include/scsi/scsi_ne=
tlink.h
 Peter> index 536752c..7445c46 100644
 Peter> --- a/include/scsi/scsi_netlink.h
 Peter> +++ b/include/scsi/scsi_netlink.h
 Peter> @@ -105,8 +105,8 @@ struct scsi_nl_host_vendor_msg {
 Peter>   *    PCI :  ID data is the 16 bit PCI Registered Vendor ID
 Peter>   */
 Peter>  #define SCSI_NL_VID_TYPE_SHIFT		56
 Peter> -#define SCSI_NL_VID_TYPE_MASK		((u64)0xFF << SCSI_NL_VID_TYPE_=
SHIFT)
 Peter> -#define SCSI_NL_VID_TYPE_PCI		((u64)0x01 << SCSI_NL_VID_TYPE_S=
HIFT)
 Peter> +#define SCSI_NL_VID_TYPE_MASK		((__u64)0xFF << SCSI_NL_VID_TYP=
E_SHIFT)
 Peter> +#define SCSI_NL_VID_TYPE_PCI		((__u64)0x01 << SCSI_NL_VID_TYPE=
_SHIFT)
 Peter>  #define SCSI_NL_VID_ID_MASK		(~ SCSI_NL_VID_TYPE_MASK)
=20
=20
 Peter> @@ -125,21 +125,21 @@ struct scsi_nl_host_vendor_msg {
 Peter>  #include <scsi/scsi_host.h>
=20
 Peter>  /* Exported Kernel Interfaces */
 Peter> -int scsi_nl_add_transport(u8 tport,
 Peter> +int scsi_nl_add_transport(__u8 tport,
 Peter>  	 int (*msg_handler)(struct sk_buff *),
 Peter>  	void (*event_handler)(struct notifier_block *, unsigned long,=
 void *));
 Peter> -void scsi_nl_remove_transport(u8 tport);
 Peter> +void scsi_nl_remove_transport(__u8 tport);
=20
 Peter> -int scsi_nl_add_driver(u64 vendor_id, struct scsi_host_templat=
e *hostt,
 Peter> +int scsi_nl_add_driver(__u64 vendor_id, struct scsi_host_templ=
ate *hostt,
 Peter>  	int (*nlmsg_handler)(struct Scsi_Host *shost, void *payload,
 Peter> -				 u32 len, u32 pid),
 Peter> +				 __u32 len, __u32 pid),
 Peter>  	void (*nlevt_handler)(struct notifier_block *nb,
 Peter>  				 unsigned long event, void *notify_ptr));
 Peter> -void scsi_nl_remove_driver(u64 vendor_id);
 Peter> +void scsi_nl_remove_driver(__u64 vendor_id);
=20
 Peter> -void scsi_nl_send_transport_msg(u32 pid, struct scsi_nl_hdr *h=
dr);
 Peter> -int scsi_nl_send_vendor_msg(u32 pid, unsigned short host_no, u=
64 vendor_id,
 Peter> -			 char *data_buf, u32 data_len);
 Peter> +void scsi_nl_send_transport_msg(__u32 pid, struct scsi_nl_hdr =
*hdr);
 Peter> +int scsi_nl_send_vendor_msg(__u32 pid, unsigned short host_no,=
 __u64 vendor_id,
 Peter> +			 char *data_buf, __u32 data_len);
=20
 Peter>  #endif /* __KERNEL__ */
=20
 Peter> --=20
 Peter> 1.6.5

--=20
Bye, Peter Korsgaard
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
