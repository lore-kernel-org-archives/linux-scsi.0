From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: aacraid question: is maximum_num_containers supposed to be minimum?
Date: Wed, 11 Jan 2012 11:28:43 +0300
Message-ID: <20120111082842.GA31452@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

MAXIMUM_NUM_CONTAINERS is consistently used as a minimum not a maximum
so I was wondering what was up with that?  This is ancient code that
predates git.

drivers/scsi/aacraid/aachba.c
   382          if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
   383                  maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
   384          fsa_dev_ptr = kzalloc(sizeof(*fsa_dev_ptr) * maximum_num_containers,
   385                          GFP_KERNEL);

Btw, if maximum_num_containers were really a maximum instead of minimum
then it should be unsigned.  That was what brought the code to my
attention initially.

drivers/scsi/aacraid/linit.c
  1235          if (shost->max_id < MAXIMUM_NUM_CONTAINERS)
  1236                  shost->max_id = MAXIMUM_NUM_CONTAINERS;
  1237          else
  1238                  shost->this_id = shost->max_id;

regards,
dan carpenter
