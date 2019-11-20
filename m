Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B33C432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 14:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A06C720727
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 14:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730359AbfKTO1f convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 09:27:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:37292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730145AbfKTO1f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 09:27:35 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 205595] New: Memory leak in scsi_init_io
Date:   Wed, 20 Nov 2019 14:27:32 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tristmd@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-205595-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205595

            Bug ID: 205595
           Summary: Memory leak in scsi_init_io
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 5.3.10
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: tristmd@gmail.com
        Regression: No

Info
===

Bug: Memory leak in scsi_init_io
Kernel: 5.3.10 (older version probably also affected)
Tested on: Debian 9 x86_64
Report date: 2019-11-20

Report
===

Syzkaller hit 'memory leak in scsi_init_io' bug.
BUG: memory leak
unreferenced object 0xffff888029b78500 (size 256):
  comm "kworker/1:1H", pid 91, jiffies 4294893374 (age 15.960s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000005e8e4bf1>] mempool_alloc+0x13e/0x340 mm/mempool.c:393
    [<00000000e8ac823a>] __sg_alloc_table+0x248/0x380 lib/scatterlist.c:302
    [<00000000205c96bd>] sg_alloc_table_chained+0x93/0x1e0 lib/sg_pool.c:132
    [<00000000f70e3ab3>] scsi_init_sgtable drivers/scsi/scsi_lib.c:993 [inline]
    [<00000000f70e3ab3>] scsi_init_io+0x11e/0x370 drivers/scsi/scsi_lib.c:1028
    [<000000004742ba93>] sr_init_command+0x47/0xc70 drivers/scsi/sr.c:395
    [<000000005ae42841>] scsi_setup_fs_cmnd drivers/scsi/scsi_lib.c:1210
[inline]
    [<000000005ae42841>] scsi_setup_cmnd drivers/scsi/scsi_lib.c:1228 [inline]
    [<000000005ae42841>] scsi_mq_prep_fn drivers/scsi/scsi_lib.c:1604 [inline]
    [<000000005ae42841>] scsi_queue_rq+0x12b2/0x2b50
drivers/scsi/scsi_lib.c:1672
    [<000000004dde2428>] blk_mq_dispatch_rq_list+0x1b6/0x1750
block/blk-mq.c:1273
    [<0000000085e21e93>] blk_mq_do_dispatch_sched+0x16b/0x430
block/blk-mq-sched.c:115
    [<00000000672472d8>] blk_mq_sched_dispatch_requests+0x3d0/0x650
block/blk-mq-sched.c:211
    [<0000000073a4e45d>] __blk_mq_run_hw_queue+0x12d/0x290 block/blk-mq.c:1403
    [<000000009f3dce52>] blk_mq_run_work_fn+0x5a/0x70 block/blk-mq.c:1636
    [<000000001749eca9>] process_one_work+0xbef/0x1bc0 kernel/workqueue.c:2269
    [<00000000b81273a0>] worker_thread+0x8c/0x1060 kernel/workqueue.c:2415
    [<000000006617feba>] kthread+0x354/0x420 kernel/kthread.c:255
    [<000000007610e117>] ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

BUG: memory leak
unreferenced object 0xffff888029b7da00 (size 256):
  comm "kworker/0:1H", pid 101, jiffies 4294900047 (age 9.287s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000005e8e4bf1>] mempool_alloc+0x13e/0x340 mm/mempool.c:393
    [<00000000e8ac823a>] __sg_alloc_table+0x248/0x380 lib/scatterlist.c:302
    [<00000000205c96bd>] sg_alloc_table_chained+0x93/0x1e0 lib/sg_pool.c:132
    [<00000000f70e3ab3>] scsi_init_sgtable drivers/scsi/scsi_lib.c:993 [inline]
    [<00000000f70e3ab3>] scsi_init_io+0x11e/0x370 drivers/scsi/scsi_lib.c:1028
    [<000000004742ba93>] sr_init_command+0x47/0xc70 drivers/scsi/sr.c:395
    [<000000005ae42841>] scsi_setup_fs_cmnd drivers/scsi/scsi_lib.c:1210
[inline]
    [<000000005ae42841>] scsi_setup_cmnd drivers/scsi/scsi_lib.c:1228 [inline]
    [<000000005ae42841>] scsi_mq_prep_fn drivers/scsi/scsi_lib.c:1604 [inline]
    [<000000005ae42841>] scsi_queue_rq+0x12b2/0x2b50
drivers/scsi/scsi_lib.c:1672
    [<000000004dde2428>] blk_mq_dispatch_rq_list+0x1b6/0x1750
block/blk-mq.c:1273
    [<0000000085e21e93>] blk_mq_do_dispatch_sched+0x16b/0x430
block/blk-mq-sched.c:115
    [<00000000672472d8>] blk_mq_sched_dispatch_requests+0x3d0/0x650
block/blk-mq-sched.c:211
    [<0000000073a4e45d>] __blk_mq_run_hw_queue+0x12d/0x290 block/blk-mq.c:1403
    [<000000009f3dce52>] blk_mq_run_work_fn+0x5a/0x70 block/blk-mq.c:1636
    [<000000001749eca9>] process_one_work+0xbef/0x1bc0 kernel/workqueue.c:2269
    [<00000000b81273a0>] worker_thread+0x8c/0x1060 kernel/workqueue.c:2415
    [<000000006617feba>] kthread+0x354/0x420 kernel/kthread.c:255
    [<000000007610e117>] ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352


Notes on the design of the Linux SCSI subsystem:

The SCSI subsystem uses a three layer design, with upper, mid, and low layers.
Every operation involving the SCSI subsystem (such as reading a sector from a
disk) uses one driver at each of the 3 levels: one upper layer driver, one
lower layer driver, and the SCSI midlayer.

The SCSI upper layer provides the interface between userspace and the kernel,
in the form of block and char device nodes for I/O and ioctl(). The SCSI lower
layer contains drivers for specific hardware devices.

In between is the SCSI mid-layer, analogous to a network routing layer such as
the IPv4 stack. The SCSI mid-layer routes a packet based data protocol between
the upper layer’s /dev nodes and the corresponding devices in the lower layer.
It manages command queues, provides error handling and power management
functions, and responds to ioctl() requests.

Ref: https://www.kernel.org/doc/html/v4.13/driver-api/scsi.html


Reproducer (Syzkaller)
===

# {Threaded:false Collide:false Repeat:true RepeatTimes:0 Procs:1 Sandbox:
Fault:false FaultCall:-1 FaultNth:0 Leak:true EnableTun:false
EnableNetDev:false EnableNetReset:false EnableCgroups:false
EnableBinfmtMisc:false EnableCloseFds:false EnableKCSAN:false
EnableDevlinkPCI:true UseTmpDir:false HandleSegv:false Repro:false Trace:false}
r0 = syz_open_dev$CDROM_DEV_LINK(&(0x7f000000e480)='/dev/cdrom\x00', 0x0,
0xa00)
gettid()
preadv(r0, &(0x7f0000001500)=[{&(0x7f0000000040)=""/170, 0xaa}, {0x0}, {0x0},
{0x0}, {0x0}, {0x0}, {0x0}, {0x0}, {0x0}, {0x0}], 0xa, 0x1)


Reproducer (C code)
===

#include <arpa/inet.h>
#include <dirent.h>
#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <net/if.h>
#include <netinet/in.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/prctl.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#include <linux/genetlink.h>
#include <linux/if_addr.h>
#include <linux/if_link.h>
#include <linux/in6.h>
#include <linux/neighbour.h>
#include <linux/net.h>
#include <linux/netlink.h>
#include <linux/rtnetlink.h>
#include <linux/veth.h>

static void sleep_ms(uint64_t ms)
{
        usleep(ms * 1000);
}

static uint64_t current_time_ms(void)
{
        struct timespec ts;
        if (clock_gettime(CLOCK_MONOTONIC, &ts))
        exit(1);
        return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
}

static bool write_file(const char* file, const char* what, ...)
{
        char buf[1024];
        va_list args;
        va_start(args, what);
        vsnprintf(buf, sizeof(buf), what, args);
        va_end(args);
        buf[sizeof(buf) - 1] = 0;
        int len = strlen(buf);
        int fd = open(file, O_WRONLY | O_CLOEXEC);
        if (fd == -1)
                return false;
        if (write(fd, buf, len) != len) {
                int err = errno;
                close(fd);
                errno = err;
                return false;
        }
        close(fd);
        return true;
}

struct nlmsg {
        char* pos;
        int nesting;
        struct nlattr* nested[8];
        char buf[1024];
};

static struct nlmsg nlmsg;

static void netlink_init(struct nlmsg* nlmsg, int typ, int flags,
                         const void* data, int size)
{
        memset(nlmsg, 0, sizeof(*nlmsg));
        struct nlmsghdr* hdr = (struct nlmsghdr*)nlmsg->buf;
        hdr->nlmsg_type = typ;
        hdr->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK | flags;
        memcpy(hdr + 1, data, size);
        nlmsg->pos = (char*)(hdr + 1) + NLMSG_ALIGN(size);
}

static void netlink_attr(struct nlmsg* nlmsg, int typ,
                         const void* data, int size)
{
        struct nlattr* attr = (struct nlattr*)nlmsg->pos;
        attr->nla_len = sizeof(*attr) + size;
        attr->nla_type = typ;
        memcpy(attr + 1, data, size);
        nlmsg->pos += NLMSG_ALIGN(attr->nla_len);
}

static int netlink_send_ext(struct nlmsg* nlmsg, int sock,
                            uint16_t reply_type, int* reply_len)
{
        if (nlmsg->pos > nlmsg->buf + sizeof(nlmsg->buf) || nlmsg->nesting)
        exit(1);
        struct nlmsghdr* hdr = (struct nlmsghdr*)nlmsg->buf;
        hdr->nlmsg_len = nlmsg->pos - nlmsg->buf;
        struct sockaddr_nl addr;
        memset(&addr, 0, sizeof(addr));
        addr.nl_family = AF_NETLINK;
        unsigned n = sendto(sock, nlmsg->buf, hdr->nlmsg_len, 0, (struct
sockaddr*)&addr, sizeof(addr));
        if (n != hdr->nlmsg_len)
        exit(1);
        n = recv(sock, nlmsg->buf, sizeof(nlmsg->buf), 0);
        if (n < sizeof(struct nlmsghdr))
        exit(1);
        if (reply_len && hdr->nlmsg_type == reply_type) {
                *reply_len = n;
                return 0;
        }
        if (n < sizeof(struct nlmsghdr) + sizeof(struct nlmsgerr))
        exit(1);
        if (hdr->nlmsg_type != NLMSG_ERROR)
        exit(1);
        return -((struct nlmsgerr*)(hdr + 1))->error;
}

static int netlink_send(struct nlmsg* nlmsg, int sock)
{
        return netlink_send_ext(nlmsg, sock, 0, NULL);
}

static int netlink_next_msg(struct nlmsg* nlmsg, unsigned int offset,
                            unsigned int total_len)
{
        struct nlmsghdr* hdr = (struct nlmsghdr*)(nlmsg->buf + offset);
        if (offset == total_len || offset + hdr->nlmsg_len > total_len)
                return -1;
        return hdr->nlmsg_len;
}

static void netlink_device_change(struct nlmsg* nlmsg, int sock, const char*
name, bool up,
                                  const char* master, const void* mac, int
macsize,
                                  const char* new_name)
{
        struct ifinfomsg hdr;
        memset(&hdr, 0, sizeof(hdr));
        if (up)
                hdr.ifi_flags = hdr.ifi_change = IFF_UP;
        hdr.ifi_index = if_nametoindex(name);
        netlink_init(nlmsg, RTM_NEWLINK, 0, &hdr, sizeof(hdr));
        if (new_name)
                netlink_attr(nlmsg, IFLA_IFNAME, new_name, strlen(new_name));
        if (master) {
                int ifindex = if_nametoindex(master);
                netlink_attr(nlmsg, IFLA_MASTER, &ifindex, sizeof(ifindex));
        }
        if (macsize)
                netlink_attr(nlmsg, IFLA_ADDRESS, mac, macsize);
        int err = netlink_send(nlmsg, sock);
        (void)err;
}

const int kInitNetNsFd = 239;

#define DEVLINK_FAMILY_NAME "devlink"

#define DEVLINK_CMD_PORT_GET 5
#define DEVLINK_CMD_RELOAD 37
#define DEVLINK_ATTR_BUS_NAME 1
#define DEVLINK_ATTR_DEV_NAME 2
#define DEVLINK_ATTR_NETDEV_NAME 7
#define DEVLINK_ATTR_NETNS_FD 137

static int netlink_devlink_id_get(struct nlmsg* nlmsg, int sock)
{
        struct genlmsghdr genlhdr;
        struct nlattr* attr;
        int err, n;
        uint16_t id = 0;
        memset(&genlhdr, 0, sizeof(genlhdr));
        genlhdr.cmd = CTRL_CMD_GETFAMILY;
        netlink_init(nlmsg, GENL_ID_CTRL, 0, &genlhdr, sizeof(genlhdr));
        netlink_attr(nlmsg, CTRL_ATTR_FAMILY_NAME, DEVLINK_FAMILY_NAME,
strlen(DEVLINK_FAMILY_NAME) + 1);
        err = netlink_send_ext(nlmsg, sock, GENL_ID_CTRL, &n);
        if (err) {
                return -1;
        }
        attr = (struct nlattr*)(nlmsg->buf + NLMSG_HDRLEN +
NLMSG_ALIGN(sizeof(genlhdr)));
        for (; (char*)attr < nlmsg->buf + n; attr = (struct
nlattr*)((char*)attr + NLMSG_ALIGN(attr->nla_len))) {
                if (attr->nla_type == CTRL_ATTR_FAMILY_ID) {
                        id = *(uint16_t*)(attr + 1);
                        break;
                }
        }
        if (!id) {
                return -1;
        }
        recv(sock, nlmsg->buf, sizeof(nlmsg->buf), 0); /* recv ack */
        return id;
}

static void netlink_devlink_netns_move(const char* bus_name, const char*
dev_name, int netns_fd)
{
        struct genlmsghdr genlhdr;
        int sock;
        int id;
        sock = socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
        if (sock == -1)
        exit(1);
        id = netlink_devlink_id_get(&nlmsg, sock);
        if (id == -1)
                goto error;
        memset(&genlhdr, 0, sizeof(genlhdr));
        genlhdr.cmd = DEVLINK_CMD_RELOAD;
        netlink_init(&nlmsg, id, 0, &genlhdr, sizeof(genlhdr));
        netlink_attr(&nlmsg, DEVLINK_ATTR_BUS_NAME, bus_name, strlen(bus_name)
+ 1);
        netlink_attr(&nlmsg, DEVLINK_ATTR_DEV_NAME, dev_name, strlen(dev_name)
+ 1);
        netlink_attr(&nlmsg, DEVLINK_ATTR_NETNS_FD, &netns_fd,
sizeof(netns_fd));
        netlink_send(&nlmsg, sock);
error:
        close(sock);
}

static struct nlmsg nlmsg2;

static void initialize_devlink_ports(const char* bus_name, const char*
dev_name,
                                     const char* netdev_prefix)
{
        struct genlmsghdr genlhdr;
        int len, total_len, id, err, offset;
        uint16_t netdev_index;
        int sock = socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
        if (sock == -1)
        exit(1);
        int rtsock = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
        if (rtsock == -1)
        exit(1);
        id = netlink_devlink_id_get(&nlmsg, sock);
        if (id == -1)
                goto error;
        memset(&genlhdr, 0, sizeof(genlhdr));
        genlhdr.cmd = DEVLINK_CMD_PORT_GET;
        netlink_init(&nlmsg, id, NLM_F_DUMP, &genlhdr, sizeof(genlhdr));
        netlink_attr(&nlmsg, DEVLINK_ATTR_BUS_NAME, bus_name, strlen(bus_name)
+ 1);
        netlink_attr(&nlmsg, DEVLINK_ATTR_DEV_NAME, dev_name, strlen(dev_name)
+ 1);
        err = netlink_send_ext(&nlmsg, sock, id, &total_len);
        if (err) {
                goto error;
        }
        offset = 0;
        netdev_index = 0;
        while ((len = netlink_next_msg(&nlmsg, offset, total_len)) != -1) {
                struct nlattr* attr = (struct nlattr*)(nlmsg.buf + offset +
NLMSG_HDRLEN + NLMSG_ALIGN(sizeof(genlhdr)));
                for (; (char*)attr < nlmsg.buf + offset + len; attr = (struct
nlattr*)((char*)attr + NLMSG_ALIGN(attr->nla_len))) {
                        if (attr->nla_type == DEVLINK_ATTR_NETDEV_NAME) {
                                char* port_name;
                                char netdev_name[IFNAMSIZ];
                                port_name = (char*)(attr + 1);
                                snprintf(netdev_name, sizeof(netdev_name),
"%s%d", netdev_prefix, netdev_index);
                                netlink_device_change(&nlmsg2, rtsock,
port_name, true, 0, 0, 0, netdev_name);
                                break;
                        }
                }
                offset += len;
                netdev_index++;
        }
error:
        close(rtsock);
        close(sock);
}

static void initialize_devlink_pci(void)
{
        int netns = open("/proc/self/ns/net", O_RDONLY);
        if (netns == -1)
        exit(1);
        int ret = setns(kInitNetNsFd, 0);
        if (ret == -1)
        exit(1);
        netlink_devlink_netns_move("pci", "0000:00:10.0", netns);
        ret = setns(netns, 0);
        if (ret == -1)
        exit(1);
        close(netns);
        initialize_devlink_ports("pci", "0000:00:10.0", "netpci");
}

static long syz_open_dev(volatile long a0, volatile long a1, volatile long a2)
{
        if (a0 == 0xc || a0 == 0xb) {
                char buf[128];
                sprintf(buf, "/dev/%s/%d:%d", a0 == 0xc ? "char" : "block",
(uint8_t)a1, (uint8_t)a2);
                return open(buf, O_RDWR, 0);
        } else {
                char buf[1024];
                char* hash;
strncpy(buf, (char*)a0, sizeof(buf) - 1);
                buf[sizeof(buf) - 1] = 0;
                while ((hash = strchr(buf, '#'))) {
                        *hash = '0' + (char)(a1 % 10);
                        a1 /= 10;
                }
                return open(buf, a2, 0);
        }
}

static void kill_and_wait(int pid, int* status)
{
        kill(-pid, SIGKILL);
        kill(pid, SIGKILL);
        int i;
        for (i = 0; i < 100; i++) {
                if (waitpid(-1, status, WNOHANG | __WALL) == pid)
                        return;
                usleep(1000);
        }
        DIR* dir = opendir("/sys/fs/fuse/connections");
        if (dir) {
                for (;;) {
                        struct dirent* ent = readdir(dir);
                        if (!ent)
                                break;
                        if (strcmp(ent->d_name, ".") == 0 ||
strcmp(ent->d_name, "..") == 0)
                                continue;
                        char abort[300];
                        snprintf(abort, sizeof(abort),
"/sys/fs/fuse/connections/%s/abort", ent->d_name);
                        int fd = open(abort, O_WRONLY);
                        if (fd == -1) {
                                continue;
                        }
                        if (write(fd, abort, 1) < 0) {
                        }
                        close(fd);
                }
                closedir(dir);
        } else {
        }
        while (waitpid(-1, status, __WALL) != pid) {
        }
}

static void setup_test()
{
        prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
        setpgrp();
        write_file("/proc/self/oom_score_adj", "1000");
}

#define KMEMLEAK_FILE "/sys/kernel/debug/kmemleak"

static void setup_leak()
{
        if (!write_file(KMEMLEAK_FILE, "scan"))
        exit(1);
        sleep(5);
        if (!write_file(KMEMLEAK_FILE, "scan"))
        exit(1);
        if (!write_file(KMEMLEAK_FILE, "clear"))
        exit(1);
}

static void check_leaks(void)
{
        int fd = open(KMEMLEAK_FILE, O_RDWR);
        if (fd == -1)
        exit(1);
        uint64_t start = current_time_ms();
        if (write(fd, "scan", 4) != 4)
        exit(1);
        sleep(1);
        while (current_time_ms() - start < 4 * 1000)
                sleep(1);
        if (write(fd, "scan", 4) != 4)
        exit(1);
        static char buf[128 << 10];
        ssize_t n = read(fd, buf, sizeof(buf) - 1);
        if (n < 0)
        exit(1);
        int nleaks = 0;
        if (n != 0) {
                sleep(1);
                if (write(fd, "scan", 4) != 4)
        exit(1);
                if (lseek(fd, 0, SEEK_SET) < 0)
        exit(1);
                n = read(fd, buf, sizeof(buf) - 1);
                if (n < 0)
        exit(1);
                buf[n] = 0;
                char* pos = buf;
                char* end = buf + n;
                while (pos < end) {
                        char* next = strstr(pos + 1, "unreferenced object");
                        if (!next)
                                next = end;
                        char prev = *next;
                        *next = 0;
                        fprintf(stderr, "BUG: memory leak\n%s\n", pos);
                        *next = prev;
                        pos = next;
                        nleaks++;
                }
        }
        if (write(fd, "clear", 5) != 5)
        exit(1);
        close(fd);
        if (nleaks)
                exit(1);
}

static void execute_one(void);

#define WAIT_FLAGS __WALL

static void loop(void)
{
        int iter;
        for (iter = 0;; iter++) {
                int pid = fork();
                if (pid < 0)
        exit(1);
                if (pid == 0) {
                        setup_test();
                        execute_one();
                        exit(0);
                }
                int status = 0;
                uint64_t start = current_time_ms();
                for (;;) {
                        if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) == pid)
                                break;
                        sleep_ms(1);
                        if (current_time_ms() - start < 5 * 1000)
                                continue;
                        kill_and_wait(pid, &status);
                        break;
                }
                check_leaks();
        }
}

uint64_t r[1] = {0xffffffffffffffff};

void execute_one(void)
{
                intptr_t res = 0;
memcpy((void*)0x2000e480, "/dev/cdrom\000", 11);
        res = syz_open_dev(0x2000e480, 0, 0xa00);
        if (res != -1)
                r[0] = res;
        syscall(__NR_gettid);
*(uint64_t*)0x20001500 = 0x20000040;
*(uint64_t*)0x20001508 = 0xaa;
*(uint64_t*)0x20001510 = 0;
*(uint64_t*)0x20001518 = 0;
*(uint64_t*)0x20001520 = 0;
*(uint64_t*)0x20001528 = 0;
*(uint64_t*)0x20001530 = 0;
*(uint64_t*)0x20001538 = 0;
*(uint64_t*)0x20001540 = 0;
*(uint64_t*)0x20001548 = 0;
*(uint64_t*)0x20001550 = 0;
*(uint64_t*)0x20001558 = 0;
*(uint64_t*)0x20001560 = 0;
*(uint64_t*)0x20001568 = 0;
*(uint64_t*)0x20001570 = 0;
*(uint64_t*)0x20001578 = 0;
*(uint64_t*)0x20001580 = 0;
*(uint64_t*)0x20001588 = 0;
*(uint64_t*)0x20001590 = 0;
*(uint64_t*)0x20001598 = 0;
        syscall(__NR_preadv, r[0], 0x20001500ul, 0xaul, 1ul);

}
int main(void)
{
                syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 3ul, 0x32ul, -1,
0);
        setup_leak();
                        loop();
        return 0;
}

-- 
You are receiving this mail because:
You are the assignee for the bug.
