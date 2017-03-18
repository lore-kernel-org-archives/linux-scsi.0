From: Xieyingtai <xieyingtai@huawei.com>
Subject: How to solve the delayed grant mapping problem with
 blkback?
Date: Sat, 18 Mar 2017 11:57:20 +0800
Message-ID: <60b116a4-0b9f-6f95-11ef-2111e8d53054@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:4328 "EHLO
        dggrg01-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750712AbdCREBU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Mar 2017 00:01:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, majordomo@vger.kernel.orglinux-scsi@vger.kernel.org

Hello,
Recently I got a problem when I use virtual machines in Xen 
virtualization, description just as follws.
Grant table and grant mapping were used for data communication with in 
Xen front end driver and
back end driver. A delay work will be set up to release grant mapping 
pages in end_block_io_op as
bio callbacks, the code as below:
static void __gnttab_unmap_refs_async(struct gntab_unmap_queue_data* item)
{
        int ret;
        int pc;

        for (pc = 0; pc < item->count; pc++) {
               if (page_count(item->pages[pc]) > 1) {
                      unsigned long delay = GNTTAB_UNMAP_REFS_DELAY * 
(item->age + 1);
                      schedule_delayed_work(&item->gnttab_work,
                                          msecs_to_jiffies(delay));
                      return;
               }
        }

        ret = gnttab_unmap_refs(item->unmap_ops, item->kunmap_ops,
                             item->pages, item->count);
        item->done(ret, item);
}

Only if the page count of grant mapping page was decrease to one, a 
response would be made to
notify the vm front end. But in the scenario which a network cable was 
extracted, the TCP transport
layer will retransmit the socket data. As a result, the grant mapping 
pages were occupied by
the TCP retransmition which may continued for a long time. And then in 
blkback driver, the grant unmap
delay work will continue until the TCP releases all the pages. As an 
application of TCP protocol, Is there any
method to solve this problem in iscsi driver layer? I have already 
attempted to modified some parameters
provide by iscsi, but it was a futile effort. The socket connection 
seems not be closed in the network cable
extracted scenario.

Thanks
