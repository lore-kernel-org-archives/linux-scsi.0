Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24CDC47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 18:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6069C2070B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 18:24:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="QV6sua0t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729727AbgEKSYC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 14:24:02 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.114]:29506 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729673AbgEKSYB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 14:24:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1589221438; i=@ts.fujitsu.com;
        bh=mCZ03AYdPA8KQ8psz6W86daHCBigtHLM/IyTOmJ+kv8=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=QV6sua0thVNvrp83/ZO958VNSkCZvOHORqeEW3s06yr9IHFAjyopAzMi0inqtK5rz
         3hOlj/KTCRbXsglnyPwzrhtd8Zcx34n55fFYy0hIiNns536/jGnOjvGmdgMp5Kkd/E
         EBZP1mNwc/Atst94oOm4LFpuxAGZTByNdPUiv24E47sV3GwGoX1p9ohUaWdaV7MgLn
         dF16qFnzZe+0oEbPMMG0ZQzGAamkF/sQg2B1j0V6QmxnbX95iWNhRjJjJhX7ylNbI2
         YRSFmqx16vEEWQNW71qqSVHY8DaUPjIKBhG0GNSV6IbQogyzT43mX3sp0Z5hPOCBH9
         fDMYvBn00XbrA==
Received: from [100.113.4.151] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-b.eu-central-1.aws.symcld.net id 67/D7-40390-D3899BE5; Mon, 11 May 2020 18:23:57 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRWlGSWpSXmKPExsViZ8MxVdd2xs4
  4g8PrJCymffjJbLHs0mcmizk3jSy6r+9gs1h+/B+TxfojGxgt/v96xWqxf9s/VovXk/6zWrQu
  fcvkwOVx+Yq3x8ent1g83u+7yuaxfstVFo/Pm+QCWKNYM/OS8isSWDMWr1rPWtCkXHF/2hWWB
  sbLMl2MnBxCArMYJabs0eli5OAQFvCV+NTK2MXIxSEisJBR4vKOU8wgDrPASUaJk1dPs0A0pE
  ksWfaGGcRmEzCQWDHpPlicV8BRYtaq34wgNouAqsTq76vA4qIC4RIvtvxhhagRlDg58wlYnFP
  AUuL55ONgcWYBM4l5mx8yQ9jiEreezGeCsOUltr+dwzyBkW8WkvZZSFpmIWmZhaRlASPLKkaL
  pKLM9IyS3MTMHF1DAwNdQ0NjXRNdIyO9xCrdJL3UUt3k1LySokSgpF5iebFecWVuck6KXl5qy
  SZGYIykFLKI7WCctfa93iFGSQ4mJVFevak744T4kvJTKjMSizPii0pzUosPMcpwcChJ8D4DyQ
  kWpaanVqRl5gDjFSYtwcGjJMK7ZDpQmre4IDG3ODMdInWKUVFKnPfwNKCEAEgiozQPrg2WIi4
  xykoJ8zIyMDAI8RSkFuVmlqDKv2IU52BUEubNBRnPk5lXAjf9FdBiJqDFD59vA1lckoiQkmpg
  ilFZ89n0d9jH+1f37uLxmuy3nZPlaGnDDt7rN7rZv6UFz28I6YthZtRZtt8xMPfA6QdOd/49n
  bnPhfGgcaaB949ADp2grkczLyeVF/DOfyDSp/nmwfGK6Lur83axfeK4UF3ErV7+5MtM4xPCKp
  vbb+REvuFV411UMCnJUO+Kv6ZI7pLzfL+0Gaa02IkufD+n61qzMPfyitcMHNysWepPmDPr438
  rycZU3rzJJray8kPU1iufJ9nvvmziwqN1I5ojIWCt6DntvOsXHx+ZcuflTsfeopb/4boSbDVd
  cZPLFt04/1s34kvMpxlL2WubJl34cdz+w9Nzp2YnNL/e/OBN5reEjhPeEnF1lm6b+69PVGIpz
  kg01GIuKk4EAHyPu6qMAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-7.tower-245.messagelabs.com!1589221436!1328578!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 19562 invoked from network); 11 May 2020 18:23:57 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-7.tower-245.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 11 May 2020 18:23:57 -0000
Received: from [172.17.80.59] ([172.17.80.59])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with ESMTP id 04BIN0ed007288;
        Mon, 11 May 2020 19:23:08 +0100
Subject: Re: [PATCH 03/15] target: add helper to parse acl and transport name
To:     Mike Christie <mchristi@redhat.com>, bvanassche@acm.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juergen Gross <jgross@suse.com>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-4-mchristi@redhat.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <20302416-6b4a-e9eb-695b-c4dcf50d02dd@ts.fujitsu.com>
Date:   Mon, 11 May 2020 20:22:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.1.0
MIME-Version: 1.0
In-Reply-To: <20200510215744.21999-4-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/10/20 23:57, Mike Christie wrote:
> The drivers that emulate the initiator port id (loop, scsi vhost, xen scsiback)
> do almost the extact same parsing when making their I_T_nexus. This adds a
> helper that parses out the acl name and port name from the user buffer, so
> these types of drivers drop prefixes like "naa." when they need to for the
> SCSI SPC4 TransportID SAS address, but then keep it for the LIO ACL name.
> 
> The next patches will then convert those drivers.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Juergen Gross <jgross@suse.com>
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>   drivers/target/target_core_fabric_lib.c | 73 +++++++++++++++++++++++++++++++++
>   include/target/target_core_fabric.h     |  2 +
>   2 files changed, 75 insertions(+)
> 
> diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
> index e89b3d8..81ed7d5 100644
> --- a/drivers/target/target_core_fabric_lib.c
> +++ b/drivers/target/target_core_fabric_lib.c
> @@ -423,6 +423,79 @@ const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
>   	return buf + offset;
>   }
>   
> +/**
> + * target_parse_emulated_name - parse TransportID and acl name from user buffer
> + * @proto_id: SCSI protocol identifier
> + * @user_buf: buffer with emualted name to extract acl and TransportID from
> + * @acl_name: buffer to store se_node_acl name in
> + * @max_name_len: len of acl_name buffer
> + * @tpt_id_name: Pointer to the TransportID name will be stored here.
> + */
> +int target_parse_emulated_name(u8 proto_id, const char *user_buf,
> +			       unsigned char *acl_name, int max_name_len,
> +			       unsigned char **tpt_id_name)
> +{
> +	int user_len = strlen(user_buf);
> +	char *proto_prefix, *name_start;
> +
> +	if (user_len >= max_name_len) {
> +		pr_err("Emulated name: %s, exceeds max: %d\n", user_buf,
> +		       max_name_len);
> +		return -EINVAL;
> +	}
> +
> +	switch (proto_id) {
> +	case SCSI_PROTOCOL_SAS:
> +		proto_prefix = "naa.";
> +		break;
> +	case SCSI_PROTOCOL_FCP:
> +		proto_prefix = "fc.";
> +		break;
> +	case SCSI_PROTOCOL_ISCSI:
> +		proto_prefix = "iqn.";
> +		break;
> +	default:
> +		pr_err("Unsupported proto_id: 0x%02x\n", proto_id);
> +		return -EINVAL;
> +	}
> +
> +	name_start = strstr(user_buf, proto_prefix);
> +	if (!name_start) {
> +		pr_err("Invalid emulated name %s. Must start with %s\n",
> +		       user_buf, proto_prefix);
> +		return -EINVAL;
> +	}
> +
> +	switch (proto_id) {
> +	case SCSI_PROTOCOL_SAS:
> +		sprintf(acl_name, name_start);
> +		break;
> +	case SCSI_PROTOCOL_FCP:
> +		sprintf(acl_name, &name_start[3]); /* Skip over "fc." */
> +		break;

Would it make sense to check acl_name for SAS and FCP according to
the assumptions made in (sas|fc)_get_pr_transport_id() how the
string should look like?

- SAS: 8 hex digits
- FC: 8 pairs of 2 hex digits separated by 7 colons

For compatibility reasons 16 hex digits could be allowed alternatively
for FC, if fc_get_pr_transport_id() is enhanced accordingly.

> +	case SCSI_PROTOCOL_ISCSI:
> +		sprintf(acl_name, name_start);
> +		break;
> +	}
> +
> +	if (acl_name[user_len - 1] == '\n')
> +		acl_name[user_len - 1] = '\0';
> +
> +	if (proto_id == SCSI_PROTOCOL_SAS) {
> +		/*
> +		 * target_setup_session will want the naa. prefix to match
> +		 * the ACL name, but the t10 transport id only wants the
> +		 * address.
> +		 */
> +		*tpt_id_name = acl_name + 4;
> +	} else {
> +		*tpt_id_name = acl_name;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(target_parse_emulated_name);
> +
>   struct t10_transport_id *target_create_transport_id(u8 proto, const char *name,
>   						    const char *session_id)
>   {
> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
> index af1dd81..0113e1c 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -125,6 +125,8 @@ struct target_core_fabric_ops {
>   int target_depend_item(struct config_item *item);
>   void target_undepend_item(struct config_item *item);
>   
> +int target_parse_emulated_name(u8, const char *, unsigned char *, int,
> +			       unsigned char **);
>   struct t10_transport_id *target_create_transport_id(u8, const char *,
>   						    const char *);
>   void target_free_transport_id(struct t10_transport_id *);
> 
