Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CE5C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 17:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB571206F7
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 17:44:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="u/mfGZJd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403935AbgKXRoP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 12:44:15 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57324 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403887AbgKXRoP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2020 12:44:15 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHea3A017004;
        Tue, 24 Nov 2020 17:44:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=WIFmrkTepan6PjzJxZUZ4xEDsxGy1sOeQTEnIL3CUL4=;
 b=u/mfGZJdSwetrvbj2Oo9wxBm7BJQfmQkT3XouSlkai+ANTkiJexQrHQtaJRc7yqdhTKq
 Sub+uxwTJjlxWBboiV2liVL0vBPMUzSPkpRFTLYo88xW36A2Cs8Rs2PG+3yEp7neTP47
 xgrfuSKdxRpwDp+W2Yf9axS26fV6gG2TCNlH4sGZBJcOM2rc01cMBOLomFnQDbBYMGsi
 ki7NjH4Ct+2zbJpgP54KMK1OCCkRjEWp/ohCOx8x1c99kMuQdpDKT0oj1qfQpL/n9fll
 fqm5bP/0l/3cakTUyEuKtXLiH0YZCT7EldZMkFlOM5o3MYkMYOMj0caXDCn34InpjfWG Nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34xrdav8yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 17:44:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHe0ho104130;
        Tue, 24 Nov 2020 17:44:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34ycfnms9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 17:44:06 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AOHi4KP029609;
        Tue, 24 Nov 2020 17:44:05 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Nov 2020 09:44:04 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v7 4/5] scsi_transport_fc: Added store fucntionality to
 set the rport port_state using sysfs
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <1605070685-20945-5-git-send-email-muneendra.kumar@broadcom.com>
Date:   Tue, 24 Nov 2020 11:44:04 -0600
Cc:     linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        hare@suse.de, jsmart2021@gmail.com, emilne@redhat.com,
        mkumar@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <8D1BAA0B-610D-4A9F-A51B-8BC547717A0B@oracle.com>
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
 <1605070685-20945-5-git-send-email-muneendra.kumar@broadcom.com>
To:     Muneendra <muneendra.kumar@broadcom.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9815 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9815 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Nov 10, 2020, at 10:58 PM, Muneendra <muneendra.kumar@broadcom.com> =
wrote:
>=20
> Added a store functionality to set rport port_state using sysfs
> under  fc_remote_ports/rport-*/port_state
>=20
> With this functionality the user can move the port_state from
> Marginal -> Online and Online->Marginal.
>=20
> On Marginal :This interface will set SCMD_NORETRIES_ABORT bit in
> scmd->state for all the pending io's on the scsi device associated
> with target port.
>=20
> On Online :This interface will clear SCMD_NORETRIES_ABORT bit in
> scmd->state for all the pending io's on the scsi device associated
> with target port.
>=20
> Below is the interface provided to set the port state to Marginal
> and Online.
>=20
> echo "Marginal" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state
> echo "Online" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state
>=20
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
>=20
> ---
> v7:
> No change
>=20
> v6:
> No change
>=20
> v5:
> No change
>=20
> v4:
> Addressed the error reported by kernel test robot
> Removed the code needed to traverse all the devices under rport
> to set/clear SCMD_NORETRIES_ABORT
> Removed unncessary comments.
> Return the error values on failure while setting the port_state
>=20
> v3:
> Removed the port_state from starget attributes.
> Enabled the store functionality for port_state under remote port.
> used the starget_for_each_device to traverse around all the devices
> under rport
>=20
> v2:
> Changed from a noretries_abort attribute under fc_transport/target*/ =
to
> port_state for changing the port_state to a marginal state
> ---
> drivers/scsi/scsi_transport_fc.c | 56 ++++++++++++++++++++++++++++++--
> 1 file changed, 54 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_transport_fc.c =
b/drivers/scsi/scsi_transport_fc.c
> index ffd25195ae62..d378ca4a60fe 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -1238,7 +1238,59 @@ show_fc_rport_roles (struct device *dev, struct =
device_attribute *attr,
> static FC_DEVICE_ATTR(rport, roles, S_IRUGO,
> 		show_fc_rport_roles, NULL);
>=20
> -fc_private_rport_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
> +static ssize_t fc_rport_set_marginal_state(struct device *dev,
> +						struct device_attribute =
*attr,
> +						const char *buf, size_t =
count)
> +{
> +	struct fc_rport *rport =3D transport_class_to_rport(dev);
> +	enum fc_port_state port_state;
> +	int ret =3D 0;
> +
> +	ret =3D get_fc_port_state_match(buf, &port_state);
> +	if (ret)
> +		return -EINVAL;
> +	if (port_state =3D=3D FC_PORTSTATE_MARGINAL) {
> +		/*
> +		 * Change the state to marginal only if the
> +		 * current rport state is Online
> +		 * Allow only Online->marginal
> +		 */
> +		if (rport->port_state =3D=3D FC_PORTSTATE_ONLINE)
> +			rport->port_state =3D port_state;
> +		else
> +			return -EINVAL;
> +	} else if (port_state =3D=3D FC_PORTSTATE_ONLINE) {
> +		/*
> +		 * Change the state to Online only if the
> +		 * current rport state is Marginal
> +		 * Allow only  MArginal->Online
> +		 */
> +		if (rport->port_state =3D=3D FC_PORTSTATE_MARGINAL)
> +			rport->port_state =3D port_state;
> +		else
> +			return -EINVAL;
> +	} else
> +		return -EINVAL;
> +	return count;
> +}
> +
> +static ssize_t
> +show_fc_rport_port_state(struct device *dev,
> +				struct device_attribute *attr, char =
*buf)
> +{
> +	const char *name;
> +	struct fc_rport *rport =3D transport_class_to_rport(dev);
> +
> +	name =3D get_fc_port_state_name(rport->port_state);
> +	if (!name)
> +		return -EINVAL;
> +
> +	return snprintf(buf, 20, "%s\n", name);
> +}
> +
> +static FC_DEVICE_ATTR(rport, port_state, 0444 | 0200,
> +			show_fc_rport_port_state, =
fc_rport_set_marginal_state);
> +
> fc_private_rport_rd_attr(scsi_target_id, "%d\n", 20);
>=20
> /*
> @@ -2681,7 +2733,7 @@ fc_attach_transport(struct fc_function_template =
*ft)
> 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_name);
> 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_id);
> 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(roles);
> -	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_state);
> +	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(port_state);
> 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(scsi_target_id);
> 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
>=20
> --=20
> 2.26.2
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

