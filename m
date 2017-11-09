From: Julia Lawall <julia.lawall@lip6.fr>
Subject: [target:for-next 17/33] drivers/target/target_core_user.c:891:2-8:
 preceding lock on line 791 (fwd)
Date: Thu, 9 Nov 2017 08:21:47 +0800 (CST)
Message-ID: <alpine.DEB.2.20.1711090819580.9152@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>
Cc: kbuild-all@01.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

Please check whether an unlock is needed before the return on line 891.

julia

---------- Forwarded message ----------
Date: Wed, 8 Nov 2017 15:05:33 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [target:for-next 17/33] drivers/target/target_core_user.c:891:2-8:
    preceding lock on line 791

CC: kbuild-all@01.org
CC: linux-rdma@vger.kernel.org
CC: target-devel@vger.kernel.org
CC: linux-scsi@vger.kernel.org
CC: Nicholas Bellinger <nab@linux-iscsi.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next
head:   3fc9fb13a4b2576aeab86c62fd64eb29ab68659c
commit: 0d44374c1aaec7c81b470d3b5f955bc270711f9c [17/33] tcmu: fix double se_cmd completion
:::::: branch date: 3 hours ago
:::::: commit date: 3 days ago

>> drivers/target/target_core_user.c:891:2-8: preceding lock on line 791
   drivers/target/target_core_user.c:891:2-8: preceding lock on line 823

# https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git/commit/?id=0d44374c1aaec7c81b470d3b5f955bc270711f9c
git remote add target https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git
git remote update target
git checkout 0d44374c1aaec7c81b470d3b5f955bc270711f9c
vim +891 drivers/target/target_core_user.c

0d44374c Mike Christie    2017-10-25  757
02eb924f Andy Grover      2016-10-06  758  static sense_reason_t
02eb924f Andy Grover      2016-10-06  759  tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
7c9e7a6f Andy Grover      2014-10-01  760  {
7c9e7a6f Andy Grover      2014-10-01  761  	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
7c9e7a6f Andy Grover      2014-10-01  762  	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
7c9e7a6f Andy Grover      2014-10-01  763  	size_t base_command_size, command_size;
7c9e7a6f Andy Grover      2014-10-01  764  	struct tcmu_mailbox *mb;
7c9e7a6f Andy Grover      2014-10-01  765  	struct tcmu_cmd_entry *entry;
7c9e7a6f Andy Grover      2014-10-01  766  	struct iovec *iov;
141685a3 Xiubo Li         2017-05-02  767  	int iov_cnt, ret;
7c9e7a6f Andy Grover      2014-10-01  768  	uint32_t cmd_head;
7c9e7a6f Andy Grover      2014-10-01  769  	uint64_t cdb_off;
f97ec7db Ilias Tsitsimpis 2015-04-23  770  	bool copy_to_data_area;
ab22d260 Xiubo Li         2017-03-27  771  	size_t data_length = tcmu_cmd_get_data_length(tcmu_cmd);
7c9e7a6f Andy Grover      2014-10-01  772
7c9e7a6f Andy Grover      2014-10-01  773  	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags))
02eb924f Andy Grover      2016-10-06  774  		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
7c9e7a6f Andy Grover      2014-10-01  775
7c9e7a6f Andy Grover      2014-10-01  776  	/*
7c9e7a6f Andy Grover      2014-10-01  777  	 * Must be a certain minimum size for response sense info, but
7c9e7a6f Andy Grover      2014-10-01  778  	 * also may be larger if the iov array is large.
7c9e7a6f Andy Grover      2014-10-01  779  	 *
fe25cc34 Xiubo Li         2017-05-02  780  	 * We prepare as many iovs as possbile for potential uses here,
fe25cc34 Xiubo Li         2017-05-02  781  	 * because it's expensive to tell how many regions are freed in
fe25cc34 Xiubo Li         2017-05-02  782  	 * the bitmap & global data pool, as the size calculated here
fe25cc34 Xiubo Li         2017-05-02  783  	 * will only be used to do the checks.
fe25cc34 Xiubo Li         2017-05-02  784  	 *
fe25cc34 Xiubo Li         2017-05-02  785  	 * The size will be recalculated later as actually needed to save
fe25cc34 Xiubo Li         2017-05-02  786  	 * cmd area memories.
7c9e7a6f Andy Grover      2014-10-01  787  	 */
fe25cc34 Xiubo Li         2017-05-02  788  	base_command_size = tcmu_cmd_get_base_cmd_size(tcmu_cmd->dbi_cnt);
fe25cc34 Xiubo Li         2017-05-02  789  	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
7c9e7a6f Andy Grover      2014-10-01  790
b6df4b79 Xiubo Li         2017-05-02 @791  	mutex_lock(&udev->cmdr_lock);
7c9e7a6f Andy Grover      2014-10-01  792
7c9e7a6f Andy Grover      2014-10-01  793  	mb = udev->mb_addr;
7c9e7a6f Andy Grover      2014-10-01  794  	cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
554617b2 Andy Grover      2016-08-25  795  	if ((command_size > (udev->cmdr_size / 2)) ||
554617b2 Andy Grover      2016-08-25  796  	    data_length > udev->data_size) {
554617b2 Andy Grover      2016-08-25  797  		pr_warn("TCMU: Request of size %zu/%zu is too big for %u/%zu "
3d9b9555 Andy Grover      2016-08-25  798  			"cmd ring/data area\n", command_size, data_length,
7c9e7a6f Andy Grover      2014-10-01  799  			udev->cmdr_size, udev->data_size);
b6df4b79 Xiubo Li         2017-05-02  800  		mutex_unlock(&udev->cmdr_lock);
554617b2 Andy Grover      2016-08-25  801  		return TCM_INVALID_CDB_FIELD;
554617b2 Andy Grover      2016-08-25  802  	}
7c9e7a6f Andy Grover      2014-10-01  803
b6df4b79 Xiubo Li         2017-05-02  804  	while (!is_ring_space_avail(udev, tcmu_cmd, command_size, data_length)) {
7c9e7a6f Andy Grover      2014-10-01  805  		int ret;
7c9e7a6f Andy Grover      2014-10-01  806  		DEFINE_WAIT(__wait);
7c9e7a6f Andy Grover      2014-10-01  807
7c9e7a6f Andy Grover      2014-10-01  808  		prepare_to_wait(&udev->wait_cmdr, &__wait, TASK_INTERRUPTIBLE);
7c9e7a6f Andy Grover      2014-10-01  809
7c9e7a6f Andy Grover      2014-10-01  810  		pr_debug("sleeping for ring space\n");
b6df4b79 Xiubo Li         2017-05-02  811  		mutex_unlock(&udev->cmdr_lock);
af980e46 Mike Christie    2017-03-09  812  		if (udev->cmd_time_out)
af980e46 Mike Christie    2017-03-09  813  			ret = schedule_timeout(
af980e46 Mike Christie    2017-03-09  814  					msecs_to_jiffies(udev->cmd_time_out));
af980e46 Mike Christie    2017-03-09  815  		else
7c9e7a6f Andy Grover      2014-10-01  816  			ret = schedule_timeout(msecs_to_jiffies(TCMU_TIME_OUT));
7c9e7a6f Andy Grover      2014-10-01  817  		finish_wait(&udev->wait_cmdr, &__wait);
7c9e7a6f Andy Grover      2014-10-01  818  		if (!ret) {
7c9e7a6f Andy Grover      2014-10-01  819  			pr_warn("tcmu: command timed out\n");
02eb924f Andy Grover      2016-10-06  820  			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
7c9e7a6f Andy Grover      2014-10-01  821  		}
7c9e7a6f Andy Grover      2014-10-01  822
b6df4b79 Xiubo Li         2017-05-02  823  		mutex_lock(&udev->cmdr_lock);
7c9e7a6f Andy Grover      2014-10-01  824
7c9e7a6f Andy Grover      2014-10-01  825  		/* We dropped cmdr_lock, cmd_head is stale */
7c9e7a6f Andy Grover      2014-10-01  826  		cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
7c9e7a6f Andy Grover      2014-10-01  827  	}
7c9e7a6f Andy Grover      2014-10-01  828
f56574a2 Andy Grover      2014-10-02  829  	/* Insert a PAD if end-of-ring space is too small */
f56574a2 Andy Grover      2014-10-02  830  	if (head_to_end(cmd_head, udev->cmdr_size) < command_size) {
f56574a2 Andy Grover      2014-10-02  831  		size_t pad_size = head_to_end(cmd_head, udev->cmdr_size);
f56574a2 Andy Grover      2014-10-02  832
7c9e7a6f Andy Grover      2014-10-01  833  		entry = (void *) mb + CMDR_OFF + cmd_head;
0ad46af8 Andy Grover      2015-04-14  834  		tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_PAD);
0ad46af8 Andy Grover      2015-04-14  835  		tcmu_hdr_set_len(&entry->hdr.len_op, pad_size);
0ad46af8 Andy Grover      2015-04-14  836  		entry->hdr.cmd_id = 0; /* not used for PAD */
0ad46af8 Andy Grover      2015-04-14  837  		entry->hdr.kflags = 0;
0ad46af8 Andy Grover      2015-04-14  838  		entry->hdr.uflags = 0;
9d62bc0e Xiubo Li         2017-06-30  839  		tcmu_flush_dcache_range(entry, sizeof(*entry));
7c9e7a6f Andy Grover      2014-10-01  840
7c9e7a6f Andy Grover      2014-10-01  841  		UPDATE_HEAD(mb->cmd_head, pad_size, udev->cmdr_size);
9d62bc0e Xiubo Li         2017-06-30  842  		tcmu_flush_dcache_range(mb, sizeof(*mb));
7c9e7a6f Andy Grover      2014-10-01  843
7c9e7a6f Andy Grover      2014-10-01  844  		cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
7c9e7a6f Andy Grover      2014-10-01  845  		WARN_ON(cmd_head != 0);
7c9e7a6f Andy Grover      2014-10-01  846  	}
7c9e7a6f Andy Grover      2014-10-01  847
7c9e7a6f Andy Grover      2014-10-01  848  	entry = (void *) mb + CMDR_OFF + cmd_head;
b3743c71 Xiubo Li         2017-07-11  849  	memset(entry, 0, command_size);
0ad46af8 Andy Grover      2015-04-14  850  	tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_CMD);
7c9e7a6f Andy Grover      2014-10-01  851
3d9b9555 Andy Grover      2016-08-25  852  	/* Handle allocating space from the data area */
b6df4b79 Xiubo Li         2017-05-02  853  	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
7c9e7a6f Andy Grover      2014-10-01  854  	iov = &entry->req.iov[0];
f97ec7db Ilias Tsitsimpis 2015-04-23  855  	iov_cnt = 0;
e4648b01 Ilias Tsitsimpis 2015-04-23  856  	copy_to_data_area = (se_cmd->data_direction == DMA_TO_DEVICE
e4648b01 Ilias Tsitsimpis 2015-04-23  857  		|| se_cmd->se_cmd_flags & SCF_BIDI);
b6df4b79 Xiubo Li         2017-05-02  858  	ret = scatter_data_area(udev, tcmu_cmd, se_cmd->t_data_sg,
b6df4b79 Xiubo Li         2017-05-02  859  				se_cmd->t_data_nents, &iov, &iov_cnt,
b6df4b79 Xiubo Li         2017-05-02  860  				copy_to_data_area);
141685a3 Xiubo Li         2017-05-02  861  	if (ret) {
b6df4b79 Xiubo Li         2017-05-02  862  		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
b6df4b79 Xiubo Li         2017-05-02  863  		mutex_unlock(&udev->cmdr_lock);
b6df4b79 Xiubo Li         2017-05-02  864
141685a3 Xiubo Li         2017-05-02  865  		pr_err("tcmu: alloc and scatter data failed\n");
141685a3 Xiubo Li         2017-05-02  866  		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
141685a3 Xiubo Li         2017-05-02  867  	}
7c9e7a6f Andy Grover      2014-10-01  868  	entry->req.iov_cnt = iov_cnt;
7c9e7a6f Andy Grover      2014-10-01  869
e4648b01 Ilias Tsitsimpis 2015-04-23  870  	/* Handle BIDI commands */
e4648b01 Ilias Tsitsimpis 2015-04-23  871  	iov_cnt = 0;
b3743c71 Xiubo Li         2017-07-11  872  	if (se_cmd->se_cmd_flags & SCF_BIDI) {
ab22d260 Xiubo Li         2017-03-27  873  		iov++;
b6df4b79 Xiubo Li         2017-05-02  874  		ret = scatter_data_area(udev, tcmu_cmd,
141685a3 Xiubo Li         2017-05-02  875  					se_cmd->t_bidi_data_sg,
141685a3 Xiubo Li         2017-05-02  876  					se_cmd->t_bidi_data_nents,
141685a3 Xiubo Li         2017-05-02  877  					&iov, &iov_cnt, false);
141685a3 Xiubo Li         2017-05-02  878  		if (ret) {
b6df4b79 Xiubo Li         2017-05-02  879  			tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
b6df4b79 Xiubo Li         2017-05-02  880  			mutex_unlock(&udev->cmdr_lock);
b6df4b79 Xiubo Li         2017-05-02  881
141685a3 Xiubo Li         2017-05-02  882  			pr_err("tcmu: alloc and scatter bidi data failed\n");
141685a3 Xiubo Li         2017-05-02  883  			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
141685a3 Xiubo Li         2017-05-02  884  		}
ab22d260 Xiubo Li         2017-03-27  885  	}
b3743c71 Xiubo Li         2017-07-11  886  	entry->req.iov_bidi_cnt = iov_cnt;
26418649 Sheng Yang       2016-02-26  887
0d44374c Mike Christie    2017-10-25  888  	ret = tcmu_setup_cmd_timer(tcmu_cmd);
0d44374c Mike Christie    2017-10-25  889  	if (ret) {
0d44374c Mike Christie    2017-10-25  890  		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
0d44374c Mike Christie    2017-10-25 @891  		return TCM_OUT_OF_RESOURCES;
0d44374c Mike Christie    2017-10-25  892  	}
0d44374c Mike Christie    2017-10-25  893  	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
0d44374c Mike Christie    2017-10-25  894
fe25cc34 Xiubo Li         2017-05-02  895  	/*
fe25cc34 Xiubo Li         2017-05-02  896  	 * Recalaulate the command's base size and size according
fe25cc34 Xiubo Li         2017-05-02  897  	 * to the actual needs
fe25cc34 Xiubo Li         2017-05-02  898  	 */
fe25cc34 Xiubo Li         2017-05-02  899  	base_command_size = tcmu_cmd_get_base_cmd_size(entry->req.iov_cnt +
fe25cc34 Xiubo Li         2017-05-02  900  						       entry->req.iov_bidi_cnt);
fe25cc34 Xiubo Li         2017-05-02  901  	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
fe25cc34 Xiubo Li         2017-05-02  902
fe25cc34 Xiubo Li         2017-05-02  903  	tcmu_hdr_set_len(&entry->hdr.len_op, command_size);
fe25cc34 Xiubo Li         2017-05-02  904
7c9e7a6f Andy Grover      2014-10-01  905  	/* All offsets relative to mb_addr, not start of entry! */
7c9e7a6f Andy Grover      2014-10-01  906  	cdb_off = CMDR_OFF + cmd_head + base_command_size;
7c9e7a6f Andy Grover      2014-10-01  907  	memcpy((void *) mb + cdb_off, se_cmd->t_task_cdb, scsi_command_size(se_cmd->t_task_cdb));
7c9e7a6f Andy Grover      2014-10-01  908  	entry->req.cdb_off = cdb_off;
7c9e7a6f Andy Grover      2014-10-01  909  	tcmu_flush_dcache_range(entry, sizeof(*entry));
7c9e7a6f Andy Grover      2014-10-01  910
7c9e7a6f Andy Grover      2014-10-01  911  	UPDATE_HEAD(mb->cmd_head, command_size, udev->cmdr_size);
7c9e7a6f Andy Grover      2014-10-01  912  	tcmu_flush_dcache_range(mb, sizeof(*mb));
b6df4b79 Xiubo Li         2017-05-02  913  	mutex_unlock(&udev->cmdr_lock);
7c9e7a6f Andy Grover      2014-10-01  914
7c9e7a6f Andy Grover      2014-10-01  915  	/* TODO: only if FLUSH and FUA? */
7c9e7a6f Andy Grover      2014-10-01  916  	uio_event_notify(&udev->uio_info);
7c9e7a6f Andy Grover      2014-10-01  917
af980e46 Mike Christie    2017-03-09  918  	if (udev->cmd_time_out)
af980e46 Mike Christie    2017-03-09  919  		mod_timer(&udev->timeout, round_jiffies_up(jiffies +
af980e46 Mike Christie    2017-03-09  920  			  msecs_to_jiffies(udev->cmd_time_out)));
7c9e7a6f Andy Grover      2014-10-01  921
02eb924f Andy Grover      2016-10-06  922  	return TCM_NO_SENSE;
7c9e7a6f Andy Grover      2014-10-01  923  }
7c9e7a6f Andy Grover      2014-10-01  924

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
