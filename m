From: Mike Christie <michaelc@cs.wisc.edu>
Subject: possible scsi driver bugs with atomic_set/atomic_read and missing
 barrier
Date: Tue, 10 Mar 2009 22:25:44 -0500
Message-ID: <49B72F38.8090703@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35162 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbZCKDZw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Mar 2009 23:25:52 -0400
Received: from [20.15.0.9] (c-75-73-66-60.hsd1.mn.comcast.net [75.73.66.60])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id n2B3PneK032500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2009 22:25:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi,

A couple scsi drivers will use a atomic_t for some host/device state.

They will do:

atomic_set(&hba->state, SOME_STATE_VALUE);

in a interrupt or thread or tasklet then in another thread they will do


if (atomic_read(&hba->state) == SOME_STATE_VALUE))



In the Documentation/atomic_ops.txt it says:

	atomic_read does not guarantee that the runtime
	initialization by any other thread is visible yet, so the user of the
	interface must take care of that with a proper implicit or 	explicit memory
	barrier.


Does this mean that the drivers should be doing a


atomic_set(&hba->state, SOME_STATE_VALUE);
smp_mb();
