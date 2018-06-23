From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/3] tcmu: track nl commands
Date: Sat, 23 Jun 2018 11:35:18 +0300
Message-ID: <20180623083518.w3upp7fb5awn7oml@mwanda>
References: <1529639560-9429-3-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <1529639560-9429-3-git-send-email-mchristi@redhat.com>
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
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, nab@linux-iscsi.org, Mike Christie <mchristi@redhat.com>, kbuild-all@01.org
List-Id: linux-scsi@vger.kernel.org

Hi Mike,

Thank you for the patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Mike-Christie/tcmu-fix-hung-netlink-requests-during-restarts/20180622-115832

smatch warnings:
drivers/target/target_core_user.c:301 tcmu_genl_cmd_done() warn: KERN_* level not at start of string

# https://github.com/0day-ci/linux/commit/0921da9c695fe2502a0d25b7758f4c93249148d7
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 0921da9c695fe2502a0d25b7758f4c93249148d7
vim +301 drivers/target/target_core_user.c

b3af66e2 Mike Christie 2017-06-23  276  
b3af66e2 Mike Christie 2017-06-23  277  static int tcmu_genl_cmd_done(struct genl_info *info, int completed_cmd)
b3af66e2 Mike Christie 2017-06-23  278  {
0921da9c Mike Christie 2018-06-21  279  	struct tcmu_dev *udev = NULL;
b3af66e2 Mike Christie 2017-06-23  280  	struct tcmu_nl_cmd *nl_cmd;
b3af66e2 Mike Christie 2017-06-23  281  	int dev_id, rc, ret = 0;
b3af66e2 Mike Christie 2017-06-23  282  
b3af66e2 Mike Christie 2017-06-23  283  	if (!info->attrs[TCMU_ATTR_CMD_STATUS] ||
b3af66e2 Mike Christie 2017-06-23  284  	    !info->attrs[TCMU_ATTR_DEVICE_ID]) {
b3af66e2 Mike Christie 2017-06-23  285  		printk(KERN_ERR "TCMU_ATTR_CMD_STATUS or TCMU_ATTR_DEVICE_ID not set, doing nothing\n");
b3af66e2 Mike Christie 2017-06-23  286  		return -EINVAL;
b3af66e2 Mike Christie 2017-06-23  287          }
b3af66e2 Mike Christie 2017-06-23  288  
b3af66e2 Mike Christie 2017-06-23  289  	dev_id = nla_get_u32(info->attrs[TCMU_ATTR_DEVICE_ID]);
b3af66e2 Mike Christie 2017-06-23  290  	rc = nla_get_s32(info->attrs[TCMU_ATTR_CMD_STATUS]);
b3af66e2 Mike Christie 2017-06-23  291  
0921da9c Mike Christie 2018-06-21  292  	mutex_lock(&tcmu_nl_cmd_mutex);
0921da9c Mike Christie 2018-06-21  293  	list_for_each_entry(nl_cmd, &tcmu_nl_cmd_list, nl_list) {
0921da9c Mike Christie 2018-06-21  294  		if (nl_cmd->udev->se_dev.dev_index == dev_id) {
0921da9c Mike Christie 2018-06-21  295  			udev = nl_cmd->udev;
0921da9c Mike Christie 2018-06-21  296  			break;
0921da9c Mike Christie 2018-06-21  297  		}
b3af66e2 Mike Christie 2017-06-23  298  	}
b3af66e2 Mike Christie 2017-06-23  299  
0921da9c Mike Christie 2018-06-21  300  	if (!udev) {
0921da9c Mike Christie 2018-06-21 @301  		pr_err(KERN_ERR "tcmu nl cmd %u/%d completion could not find device with dev id %u.\n",
                                                               ^^^^^^^^
Not required since this is already pr_err().

0921da9c Mike Christie 2018-06-21  302  		       completed_cmd, rc, dev_id);
0921da9c Mike Christie 2018-06-21  303  		ret = -ENODEV;
0921da9c Mike Christie 2018-06-21  304  		goto unlock;
0921da9c Mike Christie 2018-06-21  305  	}
0921da9c Mike Christie 2018-06-21  306  	list_del(&nl_cmd->nl_list);
b3af66e2 Mike Christie 2017-06-23  307  
0921da9c Mike Christie 2018-06-21  308  	pr_debug("%s genl cmd done got id %d curr %d done %d rc %d\n",
0921da9c Mike Christie 2018-06-21  309  		 udev->name, dev_id, nl_cmd->cmd, completed_cmd, rc);
b3af66e2 Mike Christie 2017-06-23  310  
b3af66e2 Mike Christie 2017-06-23  311  	if (nl_cmd->cmd != completed_cmd) {
0921da9c Mike Christie 2018-06-21  312  		pr_err("Mismatched commands on %s (Expecting reply for %d. Current %d).\n",
0921da9c Mike Christie 2018-06-21  313  		       udev->name, completed_cmd, nl_cmd->cmd);
b3af66e2 Mike Christie 2017-06-23  314  		ret = -EINVAL;
0921da9c Mike Christie 2018-06-21  315  		goto unlock;
b3af66e2 Mike Christie 2017-06-23  316  	}
b3af66e2 Mike Christie 2017-06-23  317  
0921da9c Mike Christie 2018-06-21  318  	nl_cmd->status = rc;
b3af66e2 Mike Christie 2017-06-23  319  	complete(&nl_cmd->complete);
0921da9c Mike Christie 2018-06-21  320  unlock:
0921da9c Mike Christie 2018-06-21  321  	mutex_unlock(&tcmu_nl_cmd_mutex);
b3af66e2 Mike Christie 2017-06-23  322  	return ret;
b3af66e2 Mike Christie 2017-06-23  323  }
b3af66e2 Mike Christie 2017-06-23  324  
