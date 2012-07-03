From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: New Defects based on recent changes in Kernel code found by
 Coverity Scan
Date: Tue, 3 Jul 2012 15:27:39 -0700
Message-ID: <20120703152739.ea7df9e6.akpm@linux-foundation.org>
References: <829BE905228AE14A9AE1A46E6F2E371605538D039D@VA3DIAXVS891.RED001.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <829BE905228AE14A9AE1A46E6F2E371605538D039D@VA3DIAXVS891.RED001.local>
Sender: linux-ext4-owner@vger.kernel.org
To: Scan Subscription <scan-subscription@coverity.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>, Bing Zhao <bzhao@marvell.com>, Robert Love <robert.w.love@intel.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 28 Jun 2012 11:32:09 -0700
Scan Subscription <scan-subscription@coverity.com> wrote:

> 
> Hi,
> 
> Based on several requests to test the recent changes to the Linux Kernel for any new defects, that may have been introduced, using Coverity SCAN, we have the results and we would share them with the larger community. To date we have found a total of 27 new defects based on changes made in the last THREE weeks. Below you can find the full summary and details of defects found including the source code snippet.
> 
> We will share this information weekly and include the list of new defects found by Coverity SCAN. You can also view the details of the defects by logging into SCAN http://scan5.coverity.com:8080   
> 
> ____________________________________________________________________________________________________________
> Summary of Defects:  
> * CID 703583: Out-of-bounds access (OVERRUN_STATIC) - Array of  uint16_t mb[4], is being accessed as mb[1],mb[2],mb[3],mb[4], instead of index from 0 to 3
> drivers/scsi/qla2xxx/qla_isr.c:92
> drivers/scsi/qla2xxx/qla_target.c:4045

cc Andrew and linux-scsi

> * CID 709112: Dereference after null check - fs/btrfs/ioctl.c, line: 1309 Comparing "device->fs_devices" to null implies that "device->fs_devices" might be null, and then it is deference
> fs/btrfs/ioctl.c:1309

Chris.

> *. CID 709078: Resource leak (RESOURCE_LEAK) - drivers/net/wireless/mwifiex/cfg80211.c, line: 935
> Assigning: "bss_cfg" = storage returned from "kzalloc(132UL, 208U)" - but was not free 
> drivers/net/wireless/mwifiex/cfg80211.c:935

bzhao

> *  CID 703581 -  NO_EFFECT Unsigned compared against 0 - This less-than-zero comparison of an unsigned value is never true. "*val < 0UL".
> drivers/scsi/fcoe/fcoe_sysfs.c:105

Robert.

> *  CID 115636: Dereference null return value - Function "ext4_get_group_desc" returns null - And 23 times out of 28 times its return value was checked against NULL 
> fs/ext4/super.c:4500

tytso & linux-ext4

> * CID 703573 Dereference after null check 
> kernel/sys.c, line: 2212

I'll fix that one.

> * CID 703579 - NO_EFFECT  - Unsigned compared against 0 - This less-than-zero comparison of an unsigned value is never true. "value < 0UL".
> drivers/platform/x86/sony-laptop.c:993

Mattia & mjg.

> ____________________________________________________________________________________________________________
> To View the defect in Coverity Scan visit, http://scan5.coverity.com:8080  
> Your username is usually your first part of your email address.
> If you don't have a username, you can request one by emailing:  scan-admin@coverity.com
> 
> ____________________________________________________________________________________________________________
> Details of Defect:-
> ____________________________________________________________________________________________________________
> CID 703583: Out-of-bounds access (OVERRUN_STATIC) - Array of  uint16_t mb[4], is being accessed as mb[1],mb[2],mb[3],mb[4], instead of index from 0 to 3
> 
> drivers/scsi/qla2xxx/qla_isr.c:92
> 33 irqreturn_t
> 34 qla2100_intr_handler(int irq, void *dev_id) 35{
> 42        uint16_t        mb[4];
> ...  
> >>> CID 703583: Out-of-bounds access (OVERRUN_STATIC) Overrunning static array "mb" of size 8 bytes by passing it as an argument to a function which indexes it at byte position 8. 
> 92                                qla2x00_async_event(vha, rsp, mb);
> ...
> 836        qlt_async_event(mb[0], vha, mb);
> 
> drivers/scsi/qla2xxx/qla_target.c
> 3958 void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
> 3959        uint16_t *mailbox)
> 3960{
> 3961
> >>> Pointer "mailbox" directly indexed by constant "4".
> 4045                ql_dbg(ql_dbg_tgt_mgt, vha, 0xf040,
> 4046                    "qla_target(%d): Async event %#x occured: "
> 4047                    "ignore (m[1]=%x, m[2]=%x, m[3]=%x, m[4]=%x)", vha->vp_idx,
> 4048                    code, le16_to_cpu(mailbox[1]), le16_to_cpu(mailbox[2]),
> 4049                    le16_to_cpu(mailbox[3]), le16_to_cpu(mailbox[4]));
> 
> 
> ____________________________________________________________________________________________________________
> CID 709112: Dereference after null check 
> 
> fs/btrfs/ioctl.c:1309
> 1256 static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
> 1257                                        void __user *arg)
> 1258 {
> ...
> >>> At conditional (1): "device->fs_devices" taking the false branch.
> >>> CID 709112: Dereference after null check (FORWARD_NULL) Comparing "device->fs_devices" to null implies that "device->fs_devices" might be null.
> 1309        if (device->fs_devices && device->fs_devices->seeding) {
> 1310                printk(KERN_INFO "btrfs: resizer unable to apply on "
> 1311                       "seeding device %llu\n", devid);
> 1312                ret = -EINVAL;
> 1313                goto out_free;
> 1314        }
> ...
> >>> Passing null variable "device->fs_devices" to function "btrfs_grow_device", which dereferences it. 
> 1367                ret = btrfs_grow_device(trans, device, new_size);
> 1368                btrfs_commit_transaction(trans, root);
> 1369        } else if (new_size < old_size) {
> >>> Passing null variable "device->fs_devices" to function "btrfs_shrink_device", which dereferences it. 
> 1370                ret = btrfs_shrink_device(device, new_size);
> 1371        }
> 1378 }
> 
> 
> ____________________________________________________________________________________________________________
> CID 709078: Resource leak (RESOURCE_LEAK) 
> 
> drivers/net/wireless/mwifiex/cfg80211.c:935
> 923 static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
> 924                                     struct net_device *dev,
> 925                                     struct cfg80211_ap_settings *params)
> 926 {
> 934
>  
> >>> CID 709078: Resource leak (RESOURCE_LEAK) Calling allocation function "kzalloc". 
> >>> Assigning: "bss_cfg" = storage returned from "kzalloc(132UL, 208U)".
> 935        bss_cfg = kzalloc(sizeof(struct mwifiex_uap_bss_param), GFP_KERNEL);
> ...
> 950
> 951        switch (params->hidden_ssid) {
> 952        case NL80211_HIDDEN_SSID_NOT_IN_USE:
> 953                bss_cfg->bcast_ssid_ctl = 1;
> 954                break;
> 955        case NL80211_HIDDEN_SSID_ZERO_LEN:
> 956                bss_cfg->bcast_ssid_ctl = 0;
> 957                break;
> >>> At conditional (6): switch case value "NL80211_HIDDEN_SSID_ZERO_CONTENTS" taking the true branch.
> 958        case NL80211_HIDDEN_SSID_ZERO_CONTENTS:
> 959                /* firmware doesn't support this type of hidden SSID */
> 960        default:
> >>> Variable "bss_cfg" going out of scope leaks the storage it points to.
> 961                return -EINVAL;
> 962        }
> 963
>  
> 
> ____________________________________________________________________________________________________________ 
> CID 703581 -  NO_EFFECT Unsigned compared against 0 - This less-than-zero comparison of an unsigned value is never true. "*val < 0UL".
> 
> drivers/scsi/fcoe/fcoe_sysfs.c:105
> 100 static int fcoe_str_to_dev_loss(const char *buf, unsigned long *val) 
> 101 {
> 102        int ret;
> 103
> 104        ret = kstrtoul(buf, 0, val);
> >>> CID 703581: Unsigned compared against 0 (NO_EFFECT) This less-than-zero comparison of an unsigned value is never true. "*val < 0UL".
> 105        if (ret || *val < 0)
> 106                return -EINVAL;
> 107        /*
> 108         * Check for overflow; dev_loss_tmo is u32
> ____________________________________________________________________________________________________________
> 
> CID 115636: Dereference null return value - Function "ext4_get_group_desc" returns null (checked 23 out of 28 times). 
> 
> fs/ext4/super.c:4500
> 4498                         */
> 4499                        for (g = 0; g < sbi->s_groups_count; g++) {
> >>> CID 115636: Dereference null return value (NULL_RETURNS) Function "ext4_get_group_desc" returns null (checked 23 out of 28 times). 
> >>> Assigning: "gdp" = null return value from "ext4_get_group_desc".
> 4500                                struct ext4_group_desc *gdp =
> 4501                                        ext4_get_group_desc(sb, g, NULL);
> 4502
> >>> Dereferencing a pointer that might be null "gdp" when calling "ext4_group_desc_csum_verify". 
> 4503                                if (!ext4_group_desc_csum_verify(sb, g, gdp)) {
> 
> >>> Assigning: "desc" = return value from "ext4_get_group_desc(sb, block_group, NULL)".
> 367        desc = ext4_get_group_desc(sb, block_group, NULL);
> >>> "desc" has its value checked in "desc".
> 368        if (!desc)
> 369                return NULL;
> 
> 
> ____________________________________________________________________________________________________________
> CID 703573 Dereference after null check
> 
> kernel/sys.c, line: 2212
> 2201 int orderly_poweroff(bool force)
> 2202 {
> ...
> 2210        int ret = -ENOMEM;
> 2211
> >>> At conditional (1): "argv == NULL" taking the true branch.
> >>> CID 703573: Dereference after null check (FORWARD_NULL) Comparing "argv" to null implies that "argv" might be null.
> 2212        if (argv == NULL) {
> 2213                printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
> 2214                       __func__, poweroff_cmd);
> 2215                goto out;
> 2216        }
> 2217
> 2218        ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_NO_WAIT,
> 2219                                      NULL, argv_cleanup, NULL);
> 2220 out:
> >>> At conditional (2): "!!!ret" taking the false branch.
> >>> At conditional (3): "!!!ret" taking the false branch.
> 2221        if (likely(!ret))
> 2222                return 0;
> 2223
> >>> At conditional (4): "ret == -12" taking the true branch.
> 2224        if (ret == -ENOMEM)
> >>> Passing null variable "argv" to function "argv_free", which dereferences it. 
> 2225                argv_free(argv);
> 2226
> 
> ____________________________________________________________________________________________________________
> 
> CID 703579: Unsigned compared against 0 (NO_EFFECT)
> 
> drivers/platform/x86/sony-laptop.c:993
> 972 static ssize_t sony_nc_sysfs_store(struct device *dev,
> 973                               struct device_attribute *attr,
> 974                               const char *buffer, size_t count)
> 975 {
> 976        unsigned long value = 0;
> ...
> 989
> 990        if (item->validate)
> 991                value = item->validate(SNC_VALIDATE_IN, value);
> 992
> >>> CID 703579: Unsigned compared against 0 (NO_EFFECT) This less-than-zero comparison of an unsigned value is never true. "value < 0UL".
> 993        if (value < 0)
> 994                return value;
> 

