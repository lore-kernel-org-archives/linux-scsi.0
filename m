From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: [BUG] scsi: ses: out of bound accessing in ses_enclosure_data_process
Date: Thu, 14 Mar 2019 11:19:31 +0800
Message-ID: <78dd3eca-7e8a-72f9-07f9-e2c7cc4569b0@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Junxiao Bi <junxiao.bi@oracle.com>, diego.gonzalez@oracle.com
List-Id: linux-scsi@vger.kernel.org

Dear all

When our customer probe the lpfc devices, they encountered odd memory corruption issues,
and we get 'out of bound' access warning at following position after open KASAN

ses_enclosure_data_process

for (i = 0; i < types; i++, type_ptr += 4) {
  for (j = 0; j < type_ptr[1]; j++) {
                   ^^^^^^^^^^^
                   out of bound

With some debug log, I got following,

page1 ffff88042d1aad20 len 32 types 5 type_ptr ffff88042d1aad64

Would anyone please give some suggestions on this ?

Thanks
Jianchao
