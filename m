From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [RFC-v2 03/12] iscsi-target: Add TCM v4 compatiable ConfigFS
 control plane
Date: Tue, 15 Mar 2011 01:54:04 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1103150130390.26293@swampdragon.chaosbits.net>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org> <1300103829-10337-4-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20294 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab1COAyZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2011 20:54:25 -0400
In-Reply-To: <1300103829-10337-4-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>

On Mon, 14 Mar 2011, Nicholas A. Bellinger wrote:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds support for /sys/kernel/config/target/iscsi using
> TCM v4.0 compatiable calls following target_core_fabric_configfs.c
> 
> This includes a number of iSCSI fabric dependent attributes upon
> target_core_fabric_configfs.c provided struct config_item_types from
> include/target/target_core_configfs.hstruct target_fabric_configfs_template
> 
> It also includes iscsi_target_nodeattrib.[c,h] for handling the
> lio_target_nacl_attrib_attrs[] store/show for iSCSI fabric dependent
> attributes.
> 
[...]

A few minor comments below. Not a thorough review by any stretch of the 
imagination, just a quick glance and then pointing out a few things that 
caught my eye.


> +	op = simple_strtoul(page, &endptr, 0);
> +	 if ((op != 1) && (op != 0)) {

Indentation is <tab><space> here, should just be <tab>.


> +		printk(KERN_ERR "Illegal value for tpg_enable: %u\n", op);
> +		return -EINVAL;
> +	}
> +	np = tpg_np->tpg_np;
> +	if (!(np)) {

if (!np) {


> +		printk(KERN_ERR "Unable to locate struct iscsi_np from"
> +				" struct iscsi_tpg_np\n");

Perhaps put the entire log message text on one line. Makes it easier to 
grep for.


> +	char buf[MAX_PORTAL_LEN];
> +
> +	if (strlen(name) > MAX_PORTAL_LEN) {
> +		printk(KERN_ERR "strlen(name): %d exceeds MAX_PORTAL_LEN: %d\n",
> +			(int)strlen(name), MAX_PORTAL_LEN);

Shouldn't this be 

     char buf[MAX_PORTAL_LEN + 1];
     
     if (strlen(name) > MAX_PORTAL_LEN) {
             printk(KERN_ERR "strlen(name): %d exceeds MAX_PORTAL_LEN: %d\n",
                     (int)strlen(name), MAX_PORTAL_LEN);

so that there is room for the terminating \0 ?


> +	snprintf(buf, MAX_PORTAL_LEN, "%s", name);
> +
> +	memset((void *)&np_addr, 0, sizeof(struct iscsi_np_addr));

Unneeded cast?


> +
> +	str = strstr(buf, "[");
> +	if ((str)) {

if (str) {


> +		str2 = strstr(str, "]");
> +		if (!(str2)) {

if (!str2) {


> +			printk(KERN_ERR "Unable to locate trailing \"]\""
> +				" in IPv6 iSCSI network portal address\n");
> +			return ERR_PTR(-EINVAL);
> +		}
> +		str++; /* Skip over leading "[" */
> +		*str2 = '\0'; /* Terminate the IPv6 address */
> +		str2 += 1; /* Skip over the "]" */

why "str++" vs "str2 += 1" and not "str++" & "str2++" ?


> +		port_str = strstr(str2, ":");
> +		if (!(port_str)) {

if (!port_str) {

> +			printk(KERN_ERR "Unable to locate \":port\""
> +				" in IPv6 iSCSI network portal address\n");
> +			return ERR_PTR(-EINVAL);
> +		}
> +		*port_str = '\0'; /* Terminate string for IP */
> +		port_str += 1; /* Skip over ":" */

port_str++;


> +		np_addr.np_port = simple_strtoul(port_str, &end_ptr, 0);
> +
> +		snprintf(np_addr.np_ipv6, IPV6_ADDRESS_SPACE, "%s", str);
> +		np_addr.np_flags |= NPF_NET_IPV6;
> +	} else {
> +		ip_str = &buf[0];
> +		port_str = strstr(ip_str, ":");
> +		if (!(port_str)) {

if (!port_str) {

> +			printk(KERN_ERR "Unable to locate \":port\""
> +				" in IPv4 iSCSI network portal address\n");
> +			return ERR_PTR(-EINVAL);
> +		}
> +		*port_str = '\0'; /* Terminate string for IP */
> +		port_str += 1; /* Skip over ":" */

port_str++;


> +static void lio_target_call_delnpfromtpg(
> +	struct se_tpg_np *se_tpg_np)
> +{
> +	struct iscsi_portal_group *tpg;
> +	struct iscsi_tpg_np *tpg_np;
> +	struct se_portal_group *se_tpg;
> +	int ret = 0;
> +

pointless initialization of 'ret' to 0

> +	tpg_np = container_of(se_tpg_np, struct iscsi_tpg_np, se_tpg_np);
> +	tpg = tpg_np->tpg;
> +	ret = iscsi_get_tpg(tpg);

'ret' is assigned to here before it's used.


> +#define DEF_NACL_PARAM(name)						\
> +static ssize_t iscsi_nacl_param_show_##name(				\
> +	struct se_node_acl *se_nacl,					\
> +	char *page)							\
> +{									\
> +	struct iscsi_session *sess;						\
> +	struct se_session *se_sess;						\
> +	ssize_t rb;							\
> +									\
> +	spin_lock_bh(&se_nacl->nacl_sess_lock);				\
> +	se_sess = se_nacl->nacl_sess;					\
> +	if (!(se_sess)) {						\

if (!se_sess) {


> +static ssize_t lio_target_nacl_show_info(
> +	struct se_node_acl *se_nacl,
> +	char *page)
> +{
> +	struct iscsi_session *sess;
> +	struct iscsi_conn *conn;
> +	struct se_session *se_sess;
> +	unsigned char *ip, buf_ipv4[IPV4_BUF_SIZE];
> +	ssize_t rb = 0;
> +
> +	spin_lock_bh(&se_nacl->nacl_sess_lock);
> +	se_sess = se_nacl->nacl_sess;
> +	if (!(se_sess))

if (!se_sess)

(not pointing out any more of these)


> +		rb += sprintf(page+rb, "No active iSCSI Session for Initiator"
> +			" Endpoint: %s\n", se_nacl->initiatorname);
> +	else {

when one branch has {}, please use them for the other as well.


> +			if (conn->net_size == IPV6_ADDRESS_SPACE)
> +				ip = &conn->ipv6_login_ip[0];
> +			else {

if () {
} else {
}


> +	u32 cmdsn_depth = 0;
> +	int ret = 0;

pointless default init of 'ret' to 0.

> +
> +	cmdsn_depth = simple_strtoul(page, &endptr, 0);
> +	if (cmdsn_depth > TA_DEFAULT_CMDSN_DEPTH_MAX) {
> +		printk(KERN_ERR "Passed cmdsn_depth: %u exceeds"
> +			" TA_DEFAULT_CMDSN_DEPTH_MAX: %u\n", cmdsn_depth,
> +			TA_DEFAULT_CMDSN_DEPTH_MAX);
> +		return -EINVAL;
> +	}
> +	acl_ci = &se_nacl->acl_group.cg_item;
> +	if (!(acl_ci)) {
> +		printk(KERN_ERR "Unable to locatel acl_ci\n");
> +		return -EINVAL;
> +	}
> +	tpg_ci = &acl_ci->ci_parent->ci_group->cg_item;
> +	if (!(tpg_ci)) {
> +		printk(KERN_ERR "Unable to locate tpg_ci\n");
> +		return -EINVAL;
> +	}
> +	wwn_ci = &tpg_ci->ci_group->cg_item;
> +	if (!(wwn_ci)) {
> +		printk(KERN_ERR "Unable to locate config_item wwn_ci\n");
> +		return -EINVAL;
> +	}
> +
> +	if (iscsi_get_tpg(tpg) < 0)
> +		return -EINVAL;
> +	/*
> +	 * iscsi_tpg_set_initiator_node_queue_depth() assumes force=1
> +	 */
> +	ret = iscsi_tpg_set_initiator_node_queue_depth(tpg,
> +				config_item_name(acl_ci), cmdsn_depth, 1);

'ret' is initialized nicely here before it is used.



> +	ssize_t len = 0;
> +

no need to initialize 'len' to 0 here - 

> +	spin_lock(&tpg->tpg_state_lock);
> +	len = sprintf(page, "%d\n",
> +			(tpg->tpg_state == TPG_STATE_ACTIVE) ? 1 : 0);

        it's initialized here.


> +static ssize_t lio_target_tpg_store_enable(
> +	struct se_portal_group *se_tpg,
> +	const char *page,
> +	size_t count)
> +{
> +	struct iscsi_portal_group *tpg = container_of(se_tpg,
> +			struct iscsi_portal_group, tpg_se_tpg);
> +	char *endptr;
> +	u32 op;
> +	int ret = 0;
> +

pointless init of 'ret'.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

