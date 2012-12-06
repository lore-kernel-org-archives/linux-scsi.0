From: Chen Gang <gang.chen@asianux.com>
Subject: [Suggestion] drivers/target/sbp/ : set tport->tpg to NULL when clean
 up for failure.
Date: Thu, 06 Dec 2012 12:24:54 +0800
Message-ID: <50C01E16.5080303@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:36656 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2LFEYF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Dec 2012 23:24:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bootc@bootc.net, nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Hello Maintainers: 

in drivers/target/sbp/sbp_target.c:

   tport->tpg must be NULL before process it in function sbp_make_tpg. (line 2185..2188)
   tport->tpg assigned a ptr (line 2198)
   if processing failed, not set tport->tpg = NULL (line 2208..2212, 2217..2221)

   we have done: when free tport->tpg, set it to NULL (line 2233..2234)

   is it valuable to let tport->tpg = NULL, when clean up for failure ?


  Regards

gchen.


2168 static struct se_portal_group *sbp_make_tpg(
2169                 struct se_wwn *wwn,
2170                 struct config_group *group,
2171                 const char *name)
2172 {
2173         struct sbp_tport *tport =
2174                 container_of(wwn, struct sbp_tport, tport_wwn);
2175 
2176         struct sbp_tpg *tpg;
2177         unsigned long tpgt;
2178         int ret;
2179 
2180         if (strstr(name, "tpgt_") != name)
2181                 return ERR_PTR(-EINVAL);
2182         if (kstrtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)
2183                 return ERR_PTR(-EINVAL);
2184 
2185         if (tport->tpg) {
2186                 pr_err("Only one TPG per Unit is possible.\n");
2187                 return ERR_PTR(-EBUSY);
2188         }
2189 
2190         tpg = kzalloc(sizeof(*tpg), GFP_KERNEL);
2191         if (!tpg) {
2192                 pr_err("Unable to allocate struct sbp_tpg\n");
2193                 return ERR_PTR(-ENOMEM);
2194         }
2195 
2196         tpg->tport = tport;
2197         tpg->tport_tpgt = tpgt;
2198         tport->tpg = tpg;
2199 
2200         /* default attribute values */
2201         tport->enable = 0;
2202         tport->directory_id = -1;
2203         tport->mgt_orb_timeout = 15;
2204         tport->max_reconnect_timeout = 5;
2205         tport->max_logins_per_lun = 1;
2206 
2207         tport->mgt_agt = sbp_management_agent_register(tport);
2208         if (IS_ERR(tport->mgt_agt)) {
2209                 ret = PTR_ERR(tport->mgt_agt);
2210                 kfree(tpg);
2211                 return ERR_PTR(ret);
2212         }
2213 
2214         ret = core_tpg_register(&sbp_fabric_configfs->tf_ops, wwn,
2215                         &tpg->se_tpg, (void *)tpg,
2216                         TRANSPORT_TPG_TYPE_NORMAL);
2217         if (ret < 0) {
2218                 sbp_management_agent_unregister(tport->mgt_agt);
2219                 kfree(tpg);
2220                 return ERR_PTR(ret);
2221         }
2222 
2223         return &tpg->se_tpg;
2224 }
2225 
2226 static void sbp_drop_tpg(struct se_portal_group *se_tpg)
2227 {
2228         struct sbp_tpg *tpg = container_of(se_tpg, struct sbp_tpg, se_tpg);
2229         struct sbp_tport *tport = tpg->tport;
2230 
2231         core_tpg_deregister(se_tpg);
2232         sbp_management_agent_unregister(tport->mgt_agt);
2233         tport->tpg = NULL;
2234         kfree(tpg);
2235 }
2236 


