From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2 17/18] megaraid_sas: Introduce various Aero
 performance modes
Date: Mon, 24 Jun 2019 12:05:55 +0300
Message-ID: <20190624090555.GP18776@kadam>
References: <20190620105208.15011-18-chandrakanth.patil@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <20190620105208.15011-18-chandrakanth.patil@broadcom.com>
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
Cc: linux-scsi@vger.kernel.org, shivasharan.srikanteshwara@broadcom.com, kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Chandrakanth Patil <chandrakanth.patil@broadcom.com>, kbuild-all@01.org, sasikumar.pc@broadcom.com
List-Id: linux-scsi@vger.kernel.org

Hi Chandrakanth,

url:    https://github.com/0day-ci/linux/commits/Chandrakanth-Patil/megaraid_sas-driver-updates-to-07-710-06-00-rc1/20190621-003611
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

New smatch warnings:
drivers/scsi/megaraid/megaraid_sas_base.c:6031 megasas_init_fw() warn: curly braces intended?

Old smatch warnings:
drivers/scsi/megaraid/megaraid_sas_base.c:1883 megasas_set_dynamic_target_properties() warn: if statement not indented
drivers/scsi/megaraid/megaraid_sas_base.c:3445 megasas_complete_cmd() error: we previously assumed 'cmd->scmd' could be null (see line 3412)
drivers/scsi/megaraid/megaraid_sas_base.c:6015 megasas_init_fw() error: we previously assumed 'fusion' could be null (see line 5914)

# https://github.com/0day-ci/linux/commit/0020c0465179c06d4dac82747eeffccc59b9a6e4
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 0020c0465179c06d4dac82747eeffccc59b9a6e4
vim +6031 drivers/scsi/megaraid/megaraid_sas_base.c

0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6018  			/*
0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6019  			 * Performance mode settings provided through module parameter-perf_mode will
0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6020  			 * take affect only for:
0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6021  			 * 1. Aero family of adapters.
0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6022  			 * 2. When user sets module parameter- perf_mode in range of 0-2.
0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6023  			 */
0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6024  			if ((perf_mode >= MR_BALANCED_PERF_MODE) &&
0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6025  				(perf_mode <= MR_LATENCY_PERF_MODE))
0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6026  				instance->perf_mode = perf_mode;
0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6027  			/*
0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6028  			 * If intr coalescing is not supported by controller FW, then IOPs
0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6029  			 * and Balanced modes are not feasible.
0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6030  			 */
0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20 @6031  				if (!intr_coalescing)

This if statement is indented as if it's part of the earlier condition
but the comments aren't so it's not clear what was intended.

0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6032  					instance->perf_mode = MR_LATENCY_PERF_MODE;
0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6033  
0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6034  		}
ea76a259b5 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6035  
0020c04651 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6036  		if (instance->perf_mode == MR_BALANCED_PERF_MODE)
ea76a259b5 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6037  			instance->low_latency_index_start =
ea76a259b5 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6038  				MR_HIGH_IOPS_QUEUE_COUNT;
ea76a259b5 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6039  		else
ea76a259b5 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6040  			instance->low_latency_index_start = 1;
ea76a259b5 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6041  
ea76a259b5 drivers/scsi/megaraid/megaraid_sas_base.c Chandrakanth Patil         2019-06-20  6042  		num_msix_req = num_online_cpus() + instance->low_latency_index_start;
