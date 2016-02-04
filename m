From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 3/4] qla2xxx: Add DebugFS node for target sess list.
Date: Thu, 4 Feb 2016 10:16:55 -0800
Message-ID: <56B39597.2020405@sandisk.com>
References: <1454604319-27947-1-git-send-email-himanshu.madhani@qlogic.com>
 <1454604319-27947-4-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1454604319-27947-4-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, Quinn Tran <quinn.tran@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On 02/04/2016 08:45 AM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@qlogic.com>
>
>   #cat  /sys/kernel/debug/qla2xxx/qla2xxx_31/tgt_sess
>   qla2xxx_31
>   Port ID   Port Name                Handle
>   ff:fc:01  21:fd:00:05:33:c7:ec:16  0
>   01:0e:00  21:00:00:24:ff:7b:8a:e4  1
>   01:0f:00  21:00:00:24:ff:7b:8a:e5  2
>   ....

Hello Quinn and Himanshu,

The above information is not only useful to people who are debugging the 
QLogic target driver but also to end users who want to check which 
initiator ports have already logged in to a target port. Hence my 
proposal to move this information from debugfs to another location (e.g. 
configfs or sysfs). Users of other target drivers are probably also 
interested in seeing which sessions are active. How about adding the 
functionality for reporting session information per target port in the 
LIO core in such a way that some attributes are available for all target 
drivers (e.g. initiator port name, SCSI command statistics) and such 
that target drivers can define additional attributes to exported for 
each session (e.g. port ID, handle, ...).

Thanks,

Bart.
