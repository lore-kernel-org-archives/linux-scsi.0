From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: iSCSI Expected Data Transfer Length for T10-PI
Date: Sun, 25 May 2014 18:30:35 +0300
Message-ID: <53820C9B.3090003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Oren Duer <oren@mellanox.com>, james.smart@emulex.com, Or Gerlitz <ogerlitz@mellanox.com>, cbm@chadalapaka.com, julians@infinidat.com, meth@il.ibm.com, david.black@emc.com
List-Id: linux-scsi@vger.kernel.org

Hey All,

Recently, iSER end-to-end T10-PI support maid it mainline.
I am wandering about the impact T10-PI should or shouldn't have on iSCSI 
header
field "Expected Data Transfer Length".

RFC-7143 states:
"the Expected Data Transfer Length field contains the number of bytes of 
data involved in this SCSI operation."
Since this field relates to *data bytes* I kept T10-PI implicit wrt this 
field. The iSCSI target calculates the
total transfer length (data + protection) from the cdb transfer length 
field and protect bits.

In FC, the fc_dl field was updated to relate to the total number of 
transfer bytes and includes
data and protection bytes. virtio_scsi was added with a header PI 
section (virtio_scsi_cmd_req_pi).

So my question is, should this field be updated to explicitly include 
T10-PI bytes like the FC equivalent fc_dl?
Or should T10-PI bytes be implicit?

I want to pin down this one to avoid a situation where the standard is 
open for interpretations.

Thanks,
Sagi.
