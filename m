From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 3/3] Storvsc: Select channel based on available
 percentage of ring buffer to write
Date: Sat, 24 Mar 2018 13:53:15 +0800
Message-ID: <201803241357.wWImiJmR%fengguang.wu@intel.com>
References: <20180323001538.31876-3-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="vtzGhvizbBRQ85DL"
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20180323001538.31876-3-longli@linuxonhyperv.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Long Li <longli@linuxonhyperv.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, kbuild-all@01.org, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Long,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on v4.16-rc6]
[cannot apply to linus/master net-next/master net/master next-20180323]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Long-Li/Vmbus-Add-function-to-report-available-ring-buffer-to-write-in-total-ring-size-percentage/20180324-124431
config: x86_64-rhel (attached as .config)
compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   drivers//scsi/storvsc_drv.c: In function 'storvsc_do_io':
>> drivers//scsi/storvsc_drv.c:1402:1: warning: the frame size of 2064 bytes is larger than 2048 bytes [-Wframe-larger-than=]
    }
    ^

vim +1402 drivers//scsi/storvsc_drv.c

d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1287  
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1288  
c1b3d067 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1289  static int storvsc_do_io(struct hv_device *device,
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1290  			 struct storvsc_cmd_request *request, u16 q_num)
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1291  {
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1292  	struct storvsc_device *stor_device;
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1293  	struct vstor_packet *vstor_packet;
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1294  	struct vmbus_channel *outgoing_channel, *channel;
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1295  	int ret = 0;
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1296  	struct cpumask alloced_mask, other_numa_mask;
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1297  	int tgt_cpu;
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1298  
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1299  	vstor_packet = &request->vstor_packet;
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1300  	stor_device = get_out_stor_device(device);
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1301  
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1302  	if (!stor_device)
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1303  		return -ENODEV;
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1304  
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1305  
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1306  	request->device  = device;
6f94d5de drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2013-06-04  1307  	/*
6f94d5de drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2013-06-04  1308  	 * Select an an appropriate channel to send the request out.
6f94d5de drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2013-06-04  1309  	 */
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1310  	if (stor_device->stor_chns[q_num] != NULL) {
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1311  		outgoing_channel = stor_device->stor_chns[q_num];
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1312  		if (outgoing_channel->target_cpu == q_num) {
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1313  			/*
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1314  			 * Ideally, we want to pick a different channel if
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1315  			 * available on the same NUMA node.
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1316  			 */
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1317  			cpumask_and(&alloced_mask, &stor_device->alloced_cpus,
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1318  				    cpumask_of_node(cpu_to_node(q_num)));
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1319  
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1320  			for_each_cpu_wrap(tgt_cpu, &alloced_mask, q_num + 1) {
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1321  				if (tgt_cpu == q_num)
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1322  					continue;
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1323  				channel = stor_device->stor_chns[tgt_cpu];
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1324  				if (hv_get_avail_to_write_percent(
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1325  							&channel->outbound)
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1326  						> ring_avail_percent_lowater) {
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1327  					outgoing_channel = channel;
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1328  					goto found_channel;
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1329  				}
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1330  			}
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1331  
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1332  			/*
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1333  			 * All the othe channels on the same NUMA node are
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1334  			 * busy. Try to use the channel with the current CPU
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1335  			 */
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1336  			if (hv_get_avail_to_write_percent(
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1337  						&outgoing_channel->outbound)
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1338  					> ring_avail_percent_lowater)
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1339  				goto found_channel;
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1340  
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1341  			/*
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1342  			 * If we reach here, all the channels on the current
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1343  			 * NUMA node are busy. Try to find a channel in
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1344  			 * other NUMA nodes
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1345  			 */
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1346  			cpumask_andnot(&other_numa_mask,
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1347  					&stor_device->alloced_cpus,
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1348  					cpumask_of_node(cpu_to_node(q_num)));
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1349  
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1350  			for_each_cpu(tgt_cpu, &other_numa_mask) {
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1351  				channel = stor_device->stor_chns[tgt_cpu];
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1352  				if (hv_get_avail_to_write_percent(
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1353  							&channel->outbound)
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1354  						> ring_avail_percent_lowater) {
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1355  					outgoing_channel = channel;
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1356  					goto found_channel;
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1357  				}
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1358  			}
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1359  		}
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1360  	} else {
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1361  		outgoing_channel = get_og_chn(stor_device, q_num);
d86adf48 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2016-12-14  1362  	}
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1363  
e75adf20 drivers/scsi/storvsc_drv.c       Long Li          2018-03-22  1364  found_channel:
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1365  	vstor_packet->flags |= REQUEST_COMPLETION_FLAG;
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1366  
8b612fa2 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2013-06-04  1367  	vstor_packet->vm_srb.length = (sizeof(struct vmscsi_request) -
8b612fa2 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2013-06-04  1368  					vmscsi_size_delta);
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1369  
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1370  
8b612fa2 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2013-06-04  1371  	vstor_packet->vm_srb.sense_info_length = sense_buffer_size;
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1372  
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1373  
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1374  	vstor_packet->vm_srb.data_transfer_length =
be0cf6ca drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2015-03-27  1375  	request->payload->range.len;
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1376  
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1377  	vstor_packet->operation = VSTOR_OPERATION_EXECUTE_SRB;
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1378  
be0cf6ca drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2015-03-27  1379  	if (request->payload->range.len) {
be0cf6ca drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2015-03-27  1380  
be0cf6ca drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2015-03-27  1381  		ret = vmbus_sendpacket_mpb_desc(outgoing_channel,
be0cf6ca drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2015-03-27  1382  				request->payload, request->payload_sz,
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1383  				vstor_packet,
8b612fa2 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2013-06-04  1384  				(sizeof(struct vstor_packet) -
8b612fa2 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2013-06-04  1385  				vmscsi_size_delta),
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1386  				(unsigned long)request);
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1387  	} else {
0147dabc drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2015-03-27  1388  		ret = vmbus_sendpacket(outgoing_channel, vstor_packet,
8b612fa2 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2013-06-04  1389  			       (sizeof(struct vstor_packet) -
8b612fa2 drivers/scsi/storvsc_drv.c       K. Y. Srinivasan 2013-06-04  1390  				vmscsi_size_delta),
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1391  			       (unsigned long)request,
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1392  			       VM_PKT_DATA_INBAND,
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1393  			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1394  	}
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1395  
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1396  	if (ret != 0)
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1397  		return ret;
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1398  
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1399  	atomic_inc(&stor_device->num_outstanding_req);
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1400  
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1401  	return ret;
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27 @1402  }
8dcf37d4 drivers/staging/hv/storvsc_drv.c K. Y. Srinivasan 2011-08-27  1403  

:::::: The code at line 1402 was first introduced by commit
:::::: 8dcf37d446f103d55b96beddb100db6a0ad8d0ba Staging: hv: storvsc: Include storvsc.c in storvsc_drv.c

:::::: TO: K. Y. Srinivasan <kys@microsoft.com>
:::::: CC: Greg Kroah-Hartman <gregkh@suse.de>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--vtzGhvizbBRQ85DL
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
hwIA

--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
devel mailing list
devel@linuxdriverproject.org
http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

--vtzGhvizbBRQ85DL--
