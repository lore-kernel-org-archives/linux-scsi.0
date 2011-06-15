From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch] SCSI: target: strlen() doesn't count the NUL terminator
Date: Wed, 15 Jun 2011 09:50:54 -0700
Message-ID: <1308156654.20109.16.camel@haakon2.linux-iscsi.org>
References: <20110614072904.GP3583@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45473 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab1FOQ7i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2011 12:59:38 -0400
In-Reply-To: <20110614072904.GP3583@shale.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, target-devel <target-devel@vger.kernel.org>

On Tue, 2011-06-14 at 10:29 +0300, Dan Carpenter wrote:
> strlen() returns the number of characters in the string not counting
> the NUL character at the end.  So if you do something like:
> 
> 	char buf[10];
> 
> 	if (strlen("0123456789") > 10)
> 		return -ETOOLONG;
> 	snprintf(buf, 10, "0123456789");
> 	printf("%s\n", buf);
> 
> then the last "9" gets chopped off and only "012345678" is printed.
> 
> Plus I threw in one small related cleanup.
> 

Committed as 97fbe262b3.  Thanks again Dan!

--nab

> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> I obviously tried to do this correctly, but it has only been compile
> tested.  Sorry for that.
> 
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index 6333a0c..852ba48 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -1144,7 +1144,7 @@ static ssize_t tcm_loop_tpg_store_nexus(
>  	 * the fabric protocol_id set in tcm_loop_make_scsi_hba(), and call
>  	 * tcm_loop_make_nexus()
>  	 */
> -	if (strlen(page) > TL_WWN_ADDR_LEN) {
> +	if (strlen(page) >= TL_WWN_ADDR_LEN) {
>  		printk(KERN_ERR "Emulated NAA Sas Address: %s, exceeds"
>  				" max: %d\n", page, TL_WWN_ADDR_LEN);
>  		return -EINVAL;
> @@ -1325,7 +1325,7 @@ struct se_wwn *tcm_loop_make_scsi_hba(
>  	return ERR_PTR(-EINVAL);
>  
>  check_len:
> -	if (strlen(name) > TL_WWN_ADDR_LEN) {
> +	if (strlen(name) >= TL_WWN_ADDR_LEN) {
>  		printk(KERN_ERR "Emulated NAA %s Address: %s, exceeds"
>  			" max: %d\n", name, tcm_loop_dump_proto_id(tl_hba),
>  			TL_WWN_ADDR_LEN);
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index b17abd1..25c1f49 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -304,7 +304,7 @@ struct target_fabric_configfs *target_fabric_configfs_init(
>  		printk(KERN_ERR "Unable to locate passed fabric name\n");
>  		return NULL;
>  	}
> -	if (strlen(name) > TARGET_FABRIC_NAME_SIZE) {
> +	if (strlen(name) >= TARGET_FABRIC_NAME_SIZE) {
>  		printk(KERN_ERR "Passed name: %s exceeds TARGET_FABRIC"
>  			"_NAME_SIZE\n", name);
>  		return NULL;
> @@ -851,7 +851,7 @@ static ssize_t target_core_dev_wwn_store_attr_vpd_unit_serial(
>  		return -EOPNOTSUPP;
>  	}
>  
> -	if ((strlen(page) + 1) > INQUIRY_VPD_SERIAL_LEN) {
> +	if (strlen(page) >= INQUIRY_VPD_SERIAL_LEN) {
>  		printk(KERN_ERR "Emulated VPD Unit Serial exceeds"
>  		" INQUIRY_VPD_SERIAL_LEN: %d\n", INQUIRY_VPD_SERIAL_LEN);
>  		return -EOVERFLOW;
> @@ -917,7 +917,7 @@ static ssize_t target_core_dev_wwn_show_attr_vpd_protocol_identifier(
>  
>  		transport_dump_vpd_proto_id(vpd, buf, VPD_TMP_BUF_SIZE);
>  
> -		if ((len + strlen(buf) > PAGE_SIZE))
> +		if ((len + strlen(buf) >= PAGE_SIZE))
>  			break;
>  
>  		len += sprintf(page+len, "%s", buf);
> @@ -962,19 +962,19 @@ static ssize_t target_core_dev_wwn_show_attr_##_name(			\
>  									\
>  		memset(buf, 0, VPD_TMP_BUF_SIZE);			\
>  		transport_dump_vpd_assoc(vpd, buf, VPD_TMP_BUF_SIZE);	\
> -		if ((len + strlen(buf) > PAGE_SIZE))			\
> +		if ((len + strlen(buf) >= PAGE_SIZE))			\
>  			break;						\
>  		len += sprintf(page+len, "%s", buf);			\
>  									\
>  		memset(buf, 0, VPD_TMP_BUF_SIZE);			\
>  		transport_dump_vpd_ident_type(vpd, buf, VPD_TMP_BUF_SIZE); \
> -		if ((len + strlen(buf) > PAGE_SIZE))			\
> +		if ((len + strlen(buf) >= PAGE_SIZE))			\
>  			break;						\
>  		len += sprintf(page+len, "%s", buf);			\
>  									\
>  		memset(buf, 0, VPD_TMP_BUF_SIZE);			\
>  		transport_dump_vpd_ident(vpd, buf, VPD_TMP_BUF_SIZE); \
> -		if ((len + strlen(buf) > PAGE_SIZE))			\
> +		if ((len + strlen(buf) >= PAGE_SIZE))			\
>  			break;						\
>  		len += sprintf(page+len, "%s", buf);			\
>  	}								\
> @@ -1299,7 +1299,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_registered_i_pts(
>  			&i_buf[0] : "", pr_reg->pr_res_key,
>  			pr_reg->pr_res_generation);
>  
> -		if ((len + strlen(buf) > PAGE_SIZE))
> +		if ((len + strlen(buf) >= PAGE_SIZE))
>  			break;
>  
>  		len += sprintf(page+len, "%s", buf);
> @@ -1496,7 +1496,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
>  				ret = -ENOMEM;
>  				goto out;
>  			}
> -			if (strlen(i_port) > PR_APTPL_MAX_IPORT_LEN) {
> +			if (strlen(i_port) >= PR_APTPL_MAX_IPORT_LEN) {
>  				printk(KERN_ERR "APTPL metadata initiator_node="
>  					" exceeds PR_APTPL_MAX_IPORT_LEN: %d\n",
>  					PR_APTPL_MAX_IPORT_LEN);
> @@ -1510,7 +1510,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
>  				ret = -ENOMEM;
>  				goto out;
>  			}
> -			if (strlen(isid) > PR_REG_ISID_LEN) {
> +			if (strlen(isid) >= PR_REG_ISID_LEN) {
>  				printk(KERN_ERR "APTPL metadata initiator_isid"
>  					"= exceeds PR_REG_ISID_LEN: %d\n",
>  					PR_REG_ISID_LEN);
> @@ -1571,7 +1571,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
>  				ret = -ENOMEM;
>  				goto out;
>  			}
> -			if (strlen(t_port) > PR_APTPL_MAX_TPORT_LEN) {
> +			if (strlen(t_port) >= PR_APTPL_MAX_TPORT_LEN) {
>  				printk(KERN_ERR "APTPL metadata target_node="
>  					" exceeds PR_APTPL_MAX_TPORT_LEN: %d\n",
>  					PR_APTPL_MAX_TPORT_LEN);
> @@ -3052,7 +3052,7 @@ static struct config_group *target_core_call_addhbatotarget(
>  	int ret;
>  
>  	memset(buf, 0, TARGET_CORE_NAME_MAX_LEN);
> -	if (strlen(name) > TARGET_CORE_NAME_MAX_LEN) {
> +	if (strlen(name) >= TARGET_CORE_NAME_MAX_LEN) {
>  		printk(KERN_ERR "Passed *name strlen(): %d exceeds"
>  			" TARGET_CORE_NAME_MAX_LEN: %d\n", (int)strlen(name),
>  			TARGET_CORE_NAME_MAX_LEN);
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 8407f9c..381e428 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -1430,7 +1430,7 @@ struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
>  	struct se_lun_acl *lacl;
>  	struct se_node_acl *nacl;
>  
> -	if (strlen(initiatorname) > TRANSPORT_IQN_LEN) {
> +	if (strlen(initiatorname) >= TRANSPORT_IQN_LEN) {
>  		printk(KERN_ERR "%s InitiatorName exceeds maximum size.\n",
>  			TPG_TFO(tpg)->get_fabric_name());
>  		*ret = -EOVERFLOW;
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index a79f518..b662db3 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -1916,7 +1916,7 @@ static int __core_scsi3_update_aptpl_buf(
>  				pr_reg->pr_res_mapped_lun);
>  		}
>  
> -		if ((len + strlen(tmp) > pr_aptpl_buf_len)) {
> +		if ((len + strlen(tmp) >= pr_aptpl_buf_len)) {
>  			printk(KERN_ERR "Unable to update renaming"
>  				" APTPL metadata\n");
>  			spin_unlock(&T10_RES(su_dev)->registration_lock);
> @@ -1934,7 +1934,7 @@ static int __core_scsi3_update_aptpl_buf(
>  			TPG_TFO(tpg)->tpg_get_tag(tpg),
>  			lun->lun_sep->sep_rtpi, lun->unpacked_lun, reg_count);
>  
> -		if ((len + strlen(tmp) > pr_aptpl_buf_len)) {
> +		if ((len + strlen(tmp) >= pr_aptpl_buf_len)) {
>  			printk(KERN_ERR "Unable to update renaming"
>  				" APTPL metadata\n");
>  			spin_unlock(&T10_RES(su_dev)->registration_lock);
> @@ -1986,7 +1986,7 @@ static int __core_scsi3_write_aptpl_to_file(
>  	memset(iov, 0, sizeof(struct iovec));
>  	memset(path, 0, 512);
>  
> -	if (strlen(&wwn->unit_serial[0]) > 512) {
> +	if (strlen(&wwn->unit_serial[0]) >= 512) {
>  		printk(KERN_ERR "WWN value for struct se_device does not fit"
>  			" into path buffer\n");
>  		return -1;

