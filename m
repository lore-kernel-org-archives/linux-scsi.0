From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/3] megaraid_sas: Rework device add code in
 AEN path
Date: Mon, 21 Jan 2019 23:06:57 +0300
Message-ID: <20190121200657.GB11828@kadam>
References: <1547831500-26751-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <1547831500-26751-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/kbuild/>
List-Post: <mailto:kbuild@lists.01.org>
List-Help: <mailto:kbuild-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=subscribe>
Errors-To: kbuild-bounces@lists.01.org
Sender: "kbuild" <kbuild-bounces@lists.01.org>
To: kbuild@01.org
Cc: linux-scsi@vger.kernel.org, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, kbuild-all@01.org, sasikumar.pc@broadcom.com
List-Id: linux-scsi@vger.kernel.org

Hi Shivasharan,

I love your patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Shivasharan-S/megaraid_sas-Rework-code-to-get-PD-and-LD-list/20190121-132655

New smatch warnings:
drivers/scsi/megaraid/megaraid_sas_base.c:7919 megasas_update_device_list() error: uninitialized symbol 'dcmd_ret'.

Old smatch warnings:
drivers/scsi/megaraid/megaraid_sas_base.c:1855 megasas_set_dynamic_target_properties() warn: if statement not indented
drivers/scsi/megaraid/megaraid_sas_base.c:3319 megasas_complete_cmd() error: we previously assumed 'cmd->scmd' could be null (see line 3286)
drivers/scsi/megaraid/megaraid_sas_base.c:5613 megasas_init_fw() error: we previously assumed 'fusion' could be null (see line 5473)
drivers/scsi/megaraid/megaraid_sas_base.c:7924 megasas_update_device_list() error: uninitialized symbol 'dcmd_ret'.

# https://github.com/0day-ci/linux/commit/3ee216cd5eece3e0480372c229cac0d992460d69
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 3ee216cd5eece3e0480372c229cac0d992460d69
vim +/dcmd_ret +7919 drivers/scsi/megaraid/megaraid_sas_base.c

b4a42213a Shivasharan S 2017-02-10  7889  
3ee216cd5 Shivasharan S 2019-01-18  7890  /*
3ee216cd5 Shivasharan S 2019-01-18  7891   * megasas_update_device_list -	Update the PD and LD device list from FW
3ee216cd5 Shivasharan S 2019-01-18  7892   *				after an AEN event notification
3ee216cd5 Shivasharan S 2019-01-18  7893   * @instance:			Adapter soft state
3ee216cd5 Shivasharan S 2019-01-18  7894   * @event_type:			Indicates type of event (PD or LD event)
3ee216cd5 Shivasharan S 2019-01-18  7895   *
3ee216cd5 Shivasharan S 2019-01-18  7896   * @return:			Success or failure
3ee216cd5 Shivasharan S 2019-01-18  7897   *
3ee216cd5 Shivasharan S 2019-01-18  7898   * Issue DCMDs to Firmware to update the internal device list in driver.
3ee216cd5 Shivasharan S 2019-01-18  7899   */
3ee216cd5 Shivasharan S 2019-01-18  7900  static
3ee216cd5 Shivasharan S 2019-01-18  7901  int megasas_update_device_list(struct megasas_instance *instance,
3ee216cd5 Shivasharan S 2019-01-18  7902  			       int event_type)
3ee216cd5 Shivasharan S 2019-01-18  7903  {
3ee216cd5 Shivasharan S 2019-01-18  7904  	int dcmd_ret;
3ee216cd5 Shivasharan S 2019-01-18  7905  
3ee216cd5 Shivasharan S 2019-01-18  7906  	if (event_type & SCAN_PD_CHANNEL) {
3ee216cd5 Shivasharan S 2019-01-18  7907  		dcmd_ret = megasas_get_pd_list(instance);
3ee216cd5 Shivasharan S 2019-01-18  7908  
3ee216cd5 Shivasharan S 2019-01-18  7909  		if (dcmd_ret != DCMD_SUCCESS)
3ee216cd5 Shivasharan S 2019-01-18  7910  			goto out;
3ee216cd5 Shivasharan S 2019-01-18  7911  	}
3ee216cd5 Shivasharan S 2019-01-18  7912  
3ee216cd5 Shivasharan S 2019-01-18  7913  	if (event_type & SCAN_VD_CHANNEL) {
3ee216cd5 Shivasharan S 2019-01-18  7914  		if (!instance->requestorId ||
3ee216cd5 Shivasharan S 2019-01-18  7915  		    (instance->requestorId &&
3ee216cd5 Shivasharan S 2019-01-18  7916  		     megasas_get_ld_vf_affiliation(instance, 0)))
3ee216cd5 Shivasharan S 2019-01-18  7917  			dcmd_ret = megasas_ld_list_query(instance,
3ee216cd5 Shivasharan S 2019-01-18  7918  					MR_LD_QUERY_TYPE_EXPOSED_TO_HOST);
3ee216cd5 Shivasharan S 2019-01-18 @7919  		if (dcmd_ret != DCMD_SUCCESS)
                                                            ^^^^^^^^^^^^^^^^^^^^^^^

Not necessarily initialized.  Probably add curly braces and indent this
etc.

3ee216cd5 Shivasharan S 2019-01-18  7920  			goto out;
3ee216cd5 Shivasharan S 2019-01-18  7921  	}
3ee216cd5 Shivasharan S 2019-01-18  7922  
3ee216cd5 Shivasharan S 2019-01-18  7923  out:
3ee216cd5 Shivasharan S 2019-01-18  7924  	return dcmd_ret;
3ee216cd5 Shivasharan S 2019-01-18  7925  }
3ee216cd5 Shivasharan S 2019-01-18  7926  
