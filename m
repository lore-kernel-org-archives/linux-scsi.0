Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011041EA7C7;
	Mon, 24 Mar 2025 08:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742806302; cv=none; b=g+5e/5l6/zFDIU/pTi0jHM4FrRjj6bfH7Loa/BlfceheaZMncxTJgDTM7YAY0GOwkeGgCNL5SBrb4Z7qM5igrs6SVe7sZyRErq867+HGY0HGnJzq8w/ErWzdCl3W8XPV1Z0iDEU/yq4FR2+hfAqyXR7ZfXhaRIQyujNyVYdRoR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742806302; c=relaxed/simple;
	bh=to3IjdK/aZxIDidItr1Z1X98BJCv5/doq2FXz5bxzxc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EzZ4jltLFejEpBRJAgoc63Oseiob5UGAW9OCxvuzI+UwxmDVeM7GMYc1XAqJK7U5iEwL9B4u5aDjm5T+Jj+nZHLBPn+mEvhzAEsYQ8Tq7MB/IOQ5Zk0nJwgyh0S+vI+c6DqfBuLcTkB+NkWkQMQP4aMT8I3a7dG4Q/WXJdW5oN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=C0XZuoT9; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=v8/6KfCN; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="C0XZuoT9";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="v8/6KfCN"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 5BF36E0002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1742806284; bh=b/coSPRwVAO18LknwNn+NW81MVSEIOnW/h0dRACfRRA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=C0XZuoT9XWn+86QpBSRvmf/ZO9tF9D6XL+2Ja7DcZDA3JBoXGAIF2FpqCySk5JKs/
	 YjSM6TnfuKNxdBUE+3c7MOB0Qj7EKCj0oZ08lBC+jatN6JJfl6gMJrV8bmjQ1mF9WG
	 Q7/IFBmrL8xvh4dDLRaZdplN5cz0oBsCopS9hXdrsDGobgckOdR0YasGfsKCJhFF43
	 Up/UHVyQUFdgNgy8/b7r+yfjY4xE744Gl2MUEiZ7iyvat8GAVcgDWRryByLIh2bySC
	 5SoSnNRAYKITQAe3iIm4VRLIV3m3XjxWVvYkAPlBasVSHHKPwTL0ehVl4EMp8phkss
	 /T+E5NLN4ZDZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1742806284; bh=b/coSPRwVAO18LknwNn+NW81MVSEIOnW/h0dRACfRRA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=v8/6KfCNj0CyebnwGEt0dKxEE2tPbgEXvAp1nPfl6gBhiYEQacUtPSK7NSXLroACI
	 M2hkl2qKEdgnZHPgXT7Hziehc7cC3E84QPleLS33vOwCZbnUn9qc5hdGFNyhGzJAqp
	 RY8/fEPmkfVXEBcSj9zLbBL1pvjKU7HAHzBJUo/YVzZvCa5No1/kSkGqhxh7Rqtirb
	 W07owI7FlS26iJobRELimMS3h2D+boLyDFh4z9QKMgaMR//FVS+sp/z/Z7h51ZZ50k
	 7DoQ91EcvhThLJal/FoyzSKVGHx1V+Kr8Qg6NGoAdVhxm+p8y7JxXrtvJc8TbwqtEU
	 xWa4WPPPygAMQ==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<hare@suse.de>, <axboe@kernel.dk>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux@yadro.com>
Subject: [PATCH 0/1] Fix not fully initialized SCSI commands
Date: Mon, 24 Mar 2025 11:49:32 +0300
Message-ID: <20250324084933.15932-1-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: RTM-EXCH-04.corp.yadro.com (10.34.9.204) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

We have encountered the following type of logs on initiators:

kernel: sd 16:0:1:84: [sdts] tag#405 timing out command, waited 720s
kernel: sd 16:0:1:84: [sdts] tag#405 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=66636s

The initiator uses dm-mpath for multipathing, the SCSI mid layer, and
the QLogic FC HBA driver (qla2xxx). After debugging, the following call
stack was identified:

blk_mq_sched_dispatch_requests()
  blk_mq_dispatch_rq_list()
    dm_mq_queue_rq()
      map_request()
        ti->type->clone_and_map_rq()    // New cloned request with tag 405
        blk_insert_cloned_request()
          scsi_queue_rq()
            qla2xxx_mqueuecommand()
              qla2xxx_dif_start_scsi_mq()

If qla2xxx_dif_start_scsi_mq() returns an error for any reason (e.g.,
due to extremely heavy traffic causing the driver to exhaust its
handles), scsi_done() -> scsi_end_request() is not called within
qla2xxx_mqueuecommand(). As a result, the SCMD_INITIALIZED flag
remains set. Next, map_request() releases the cloned request and
requeues the original request. While the cloned request is released, the
associated SCSI command retains stale data from the previous command.

If all I/O traffic stops for some extended period of time, and later
resumes, the following scenario may occur:

blk_mq_sched_dispatch_requests()
  blk_mq_dispatch_rq_list()
    dm_mq_queue_rq()
      map_request()
        ti->type->clone_and_map_rq()    // New cloned request uses tag 405 again
        blk_insert_cloned_request()
          scsi_queue_rq()


Within scsi_queue_rq(), the scsi_init_command() function does not call
scsi_initialize_rq() because the SCMD_INITIALIZED flag is already set.
Because of that, when the command completes in scsi_complete(), the
scsi_cmd_runtime_exceeded() check returns true, causing the command to
fail.

This issue appears after the commit 4abafdc4360d ("block: remove the
initialize_rq_fn blk_mq_ops method"). Before this change, the
initialize_rq_fn method forcibly initialized the SCSI command in
blk_get_request(). There may be other places where a command is queued
in scsi_queue_rq() but scsi_done() is not called.

Anastasia Kovaleva (1):
  scsi: uninit not completed scsi cmd

 drivers/scsi/scsi_lib.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--
2.40.3

