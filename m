From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Subject: RE: usb-strage not working in the latest kernel 2.4
Date: Thu, 11 Sep 2003 14:06:20 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200309110507.OAA06907@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=shift_jis
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from inet-tsb.toshiba.co.jp ([202.33.96.40]:55182 "EHLO
	inet-tsb.toshiba.co.jp") by vger.kernel.org with ESMTP
	id S265724AbTIKFK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Sep 2003 01:10:59 -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, David Brownell <david-b@pacbell.net>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

Hi Alan,

Haruo> Using ioctl (fd, USBDEVFS_RESET, 0), I tested reset.=20
Haruo> usb-storage of USB2.0 was successful.
Haruo> When FDD was used in the case of USB1.1,=20
Haruo> mount became impossible after reset.
=20
Alan> What do you mean?  What does the log show?

I'm sorry. I wrote the following programs.
The execution result is as follows.

[root@Andromeda root]# cd ~tomita/usbreset
[root@Andromeda usbreset]# ./usbreset=20
bus =3D /proc/bus/usb/001/002
=8D=87=8Cv 864
-rwxr-xr-x    1 root     root        46481  8=8C=8E 28 12:05 1.18j1.wks
-rwxr-xr-x    1 root     root        46481  8=8C=8E 28 12:05 1.18j2.wks
-rwxr-xr-x    1 root     root        46481  8=8C=8E 28 12:05 1.18j3.wks
-rwxr-xr-x    1 root     root        11829  9=8C=8E 10 17:30 15.50s.tar=
=2Egz
-rwxr-xr-x    1 root     root           16  3=8C=8E  6  2003 S99zzz
-rwxr-xr-x    1 root     root          914  4=8C=8E 10 08:58 abort-test=
=2Epatch
-rwxr-xr-x    1 root     root          938  4=8C=8E 23  2002 autoftp.ba=
t
-rwxr-xr-x    1 root     root         1412  9=8C=8E 11 13:28 fdd.txt
-rwxr-xr-x    1 root     root         3703  3=8C=8E  6  2003 halt
-rwxr-xr-x    1 root     root          378  8=8C=8E 27 17:57 iozone_tes=
t.sh
-rwxr-xr-x    1 root     root        46481  9=8C=8E  9 08:51 mr518_128M=
B_1.wks
-rwxr-xr-x    1 root     root        46481  9=8C=8E  9 08:51 mr518_128M=
B_2.wks
-rwxr-xr-x    1 root     root        46481  9=8C=8E  9 08:51 mr518_128M=
B_3.wks
-rwxr-xr-x    1 root     root        46481  9=8C=8E  9 14:32 mr518_256M=
B_1.wks
-rwxr-xr-x    1 root     root        46481  9=8C=8E  9 14:32 mr518_256M=
B_2.wks
-rwxr-xr-x    1 root     root        46481  9=8C=8E  9 14:32 mr518_256M=
B_3.wks
-rwxr-xr-x    1 root     root        46481  9=8C=8E  8 16:38 mr518_64MB=
_1.wks
-rwxr-xr-x    1 root     root        46481  9=8C=8E  8 16:38 mr518_64MB=
_2.wks
-rwxr-xr-x    1 root     root        46481  9=8C=8E  8 16:38 mr518_64MB=
_3.wks
-rwxr-xr-x    1 root     root       104118  8=8C=8E 26 02:10 patch-0825
-rwxr-xr-x    1 root     root          759  5=8C=8E 30 11:38 profile
-rwxr-xr-x    1 root     root        17081  9=8C=8E  8 20:12 rhn_err1.j=
pg
-rwxr-xr-x    1 root     root        37151  9=8C=8E  8 20:12 rhn_err2.j=
pg
-rwxr-xr-x    1 root     root         1369  9=8C=8E  8 20:16 rpm.txt
-rwxr-xr-x    1 root     root          345  4=8C=8E  3 20:15 script_cp.=
sh
-rwxr-xr-x    1 root     root          859  4=8C=8E  3 20:16 script_cp_=
hdd.sh
-rwxr-xr-x    1 root     root          539  4=8C=8E  5 14:41 script_cp_=
scsi.sh
-rwxr-xr-x    1 root     root        46481  8=8C=8E 28 12:06 v2.00.71.w=
ks
-rwxr-xr-x    1 root     root        46481  8=8C=8E 28 12:06 v2.00.72.w=
ks
-rwxr-xr-x    1 root     root        46481  8=8C=8E 28 12:06 v2.00.73.w=
ks
usb reset success 1
error: usbdevfs not opend
[root@Andromeda usbreset]#=20

[root@Andromeda root]# mount /dev/sda /mnt/floppy/
/dev/sda: Input/output error
mount: you must specify the filesystem type

---- sample program=20

int main(int argc, char **argv);
static int open_usbdevfs(char *bus);

int main(int argc, char **argv)
{
    char bus[22];
    int fd, ret=3D1, count=3D0;

    /* make bus name */=20
    snprintf(bus,22,"/proc/bus/usb/001/002");
#ifdef DEBUG
    printf("bus =3D %s\n", bus);=09
#endif /* DEBUG */

    while (1) {
        /* device open */
        if ((fd=3Dopen_usbdevfs(bus)) < 0) {
    	    printf("error: usbdevfs not opend\n");
            ret=3D0;
	    break;=20
        }
=09
        system("mount /dev/sda /mnt/floppy");
        system("ls -l /mnt/floppy");
        system("umount /dev/sda");
=09
        /* device reset */
        ret=3Dioctl(fd, USBDEVFS_RESET, 0);
        if (ret =3D=3D -1) {
            printf("error: usbdevfs_reset error %d\n", ret);
            ret =3D 0;	   =20
            break;
	}
	/* device close */
	close (fd);
        =81@=81@sleep(10);
        =81@=81@count++;
	printf("usb reset success %d\n", count);	=09
    }

    if (fd)
        close(fd);
   =20
    return 1;
}

static int open_usbdevfs(char *bus) {
    int fd;

    fd =3D open(bus, O_RDWR);
    if (fd < 0)
        return -1;

    return fd;
}

--
Haruo
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
