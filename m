From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] copy_XX_user for sg.c - take 2
Date: Mon, 15 Jul 2002 18:19:41 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020715082116.98C2A434C@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[ This one is hardly trivial: it seems correct, but... Please check ]

From: (via Rusty) william stinson <wstinson@infonie.fr>

  Hi Rusty,
  
  here is version 2 of my sg.c patch to correct indentation to 4blanks as you pointed out (I hope I didn't miss anything).
  
  This proposed patch for the sg.c driver which allows user process control of SCSI devices
          1) checks the result of copy_XX_user 
          2) returns -EFAULT in case not all data was copied
          3) releases resources in case of failure  
          4) return value of sg_read_oxfer changed from void to int in order to be able to pass back error conditions
  
  I don't have this kind of hardware so compilation checked only. 
  
  Patch also available at the following URL:
          http://www.chez.com/wstinson/linux/kernel/patch-scsi-sg
  
  
  Have a good weekend!
  William Stinson (wstinson@infonie.fr) 
  
  

--- trivial-2.5.25/drivers/scsi/sg.c.orig	Mon Jul 15 17:03:26 2002
+++ trivial-2.5.25/drivers/scsi/sg.c	Mon Jul 15 17:03:26 2002
@@ -215,7 +215,7 @@
 		      int wr_xf, int * countp, unsigned char ** up);
 static int sg_write_xfer(Sg_request * srp);
 static int sg_read_xfer(Sg_request * srp);
-static void sg_read_oxfer(Sg_request * srp, char * outp, int num_read_xfer);
+static int sg_read_oxfer(Sg_request * srp, char * outp, int num_read_xfer);
 static void sg_remove_scat(Sg_scatter_hold * schp);
 static char * sg_get_sgat_msa(Sg_scatter_hold * schp);
 static void sg_build_reserve(Sg_fd * sfp, int req_size);
@@ -377,10 +377,12 @@
     if ((k = verify_area(VERIFY_WRITE, buf, count)))
         return k;
     if (sfp->force_packid && (count >= SZ_SG_HEADER)) {
-	__copy_from_user(&old_hdr, buf, SZ_SG_HEADER);
+	if (__copy_from_user(&old_hdr, buf, SZ_SG_HEADER)) 
+	    return -EFAULT;
 	if (old_hdr.reply_len < 0) {
 	    if (count >= SZ_SG_IO_HDR) {
-		__copy_from_user(&new_hdr, buf, SZ_SG_IO_HDR);
+  	        if (__copy_from_user(&new_hdr, buf, SZ_SG_IO_HDR)) 
+		    return -EFAULT;
 		req_pack_id = new_hdr.pack_id;
 	    }
 	}
@@ -452,12 +454,14 @@
 
     /* Now copy the result back to the user buffer.  */
     if (count >= SZ_SG_HEADER) {
-	__copy_to_user(buf, &old_hdr, SZ_SG_HEADER);
-        buf += SZ_SG_HEADER;
+	if (__copy_to_user(buf, &old_hdr, SZ_SG_HEADER)) 
+	    return -EFAULT;
+	buf += SZ_SG_HEADER;
 	if (count > old_hdr.reply_len)
 	    count = old_hdr.reply_len;
 	if (count > SZ_SG_HEADER)
-	    sg_read_oxfer(srp, buf, count - SZ_SG_HEADER);
+	    if ((res = sg_read_oxfer(srp, buf, count - SZ_SG_HEADER)))
+	        return res;
     }
     else
 	count = (old_hdr.result == 0) ? 0 : -EIO;
@@ -486,13 +490,19 @@
 	    len = (len > sb_len) ? sb_len : len;
 	    if ((err = verify_area(VERIFY_WRITE, hp->sbp, len)))
 		goto err_out;
-	    __copy_to_user(hp->sbp, srp->sense_b, len);
+	    if (__copy_to_user(hp->sbp, srp->sense_b, len)) {
+	        err = -EFAULT;
+		goto err_out;
+	    }
 	    hp->sb_len_wr = len;
 	}
     }
     if (hp->masked_status || hp->host_status || hp->driver_status)
 	hp->info |= SG_INFO_CHECK;
-    copy_to_user(buf, hp, SZ_SG_IO_HDR);
+    if (copy_to_user(buf, hp, SZ_SG_IO_HDR)) {
+        err = -EFAULT;
+        goto err_out;
+    }
     err = sg_read_xfer(srp);
 err_out:
     sg_finish_rem_req(srp);
@@ -529,7 +539,8 @@
         return k;  /* protects following copy_from_user()s + get_user()s */
     if (count < SZ_SG_HEADER)
 	return -EIO;
-    __copy_from_user(&old_hdr, buf, SZ_SG_HEADER);
+    if (__copy_from_user(&old_hdr, buf, SZ_SG_HEADER)) 
+        return -EFAULT;
     blocking = !(filp->f_flags & O_NONBLOCK);
     if (old_hdr.reply_len < 0)
 	return sg_new_write(sfp, buf, count, blocking, 0, NULL);
@@ -587,7 +598,8 @@
     hp->flags = input_size;             /* structure abuse ... */
     hp->pack_id = old_hdr.pack_id;
     hp->usr_ptr = NULL;
-    __copy_from_user(cmnd, buf, cmd_size);
+    if (__copy_from_user(cmnd, buf, cmd_size)) 
+        return -EFAULT;
     k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
     return (k < 0) ? k : count;
 }
@@ -612,7 +624,10 @@
 	return -EDOM;
     }
     hp = &srp->header;
-    __copy_from_user(hp, buf, SZ_SG_IO_HDR);
+    if (__copy_from_user(hp, buf, SZ_SG_IO_HDR)) {
+	sg_remove_request(sfp, srp);
+	return -EFAULT;
+    }
     if (hp->interface_id != 'S') {
 	sg_remove_request(sfp, srp);
 	return -ENOSYS;
@@ -637,10 +652,13 @@
 	return -EMSGSIZE;
     }
     if ((k = verify_area(VERIFY_READ, hp->cmdp, hp->cmd_len))) {
+        sg_remove_request(sfp, srp);
+        return k;  /* protects following copy_from_user()s + get_user()s */
+    }
+    if (__copy_from_user(cmnd, hp->cmdp, hp->cmd_len)) {
 	sg_remove_request(sfp, srp);
-	return k;  /* protects following copy_from_user()s + get_user()s */
+	return -EFAULT; 
     }
-    __copy_from_user(cmnd, hp->cmdp, hp->cmd_len);
     if (read_only &&
 	(! sg_allow_access(cmnd[0], sfp->parentdp->device->type))) {
 	sg_remove_request(sfp, srp);
@@ -923,8 +941,8 @@
 		}
 	    }
 	    read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	    __copy_to_user((void *)arg, rinfo, SZ_SG_REQ_INFO * SG_MAX_QUEUE);
-	    return 0;
+	    return (__copy_to_user((void *)arg, rinfo, SZ_SG_REQ_INFO * SG_MAX_QUEUE)) 
+	        ? -EFAULT : 0;
 	}
     case SG_EMULATED_HOST:
 	if (sdp->detached)
@@ -972,7 +990,8 @@
 	    unsigned char opcode = WRITE_6;
 	    Scsi_Ioctl_Command * siocp = (void *)arg;
 
-	    copy_from_user(&opcode, siocp->data, 1);
+	    if (copy_from_user(&opcode, siocp->data, 1)) 
+	        return -EFAULT;
 	    if (! sg_allow_access(opcode, sdp->device->type))
 		return -EPERM;
 	}
@@ -1897,7 +1916,8 @@
 		res = sg_u_iovec(hp, iovec_count, j, 1, &usglen, &up);
 		if (res) return res;
 		usglen = (num_xfer > usglen) ? usglen : num_xfer;
-		__copy_from_user(p, up, usglen);
+		if (__copy_from_user(p, up, usglen)) 
+		    return -EFAULT;
 		p += usglen;
 		num_xfer -= usglen;
 		if (num_xfer <= 0)
@@ -1925,20 +1945,28 @@
 		    break;
 		if (ksglen > usglen) {
 		    if (usglen >= num_xfer) {
-			if (ok) __copy_from_user(p, up, num_xfer);
+			if (ok) 
+			    if (__copy_from_user(p, up, num_xfer))
+			        return -EFAULT;
 			return 0;
 		    }
-		    if (ok) __copy_from_user(p, up, usglen);
+		    if (ok) 
+		        if (__copy_from_user(p, up, usglen)) 
+			    return -EFAULT;
 		    p += usglen;
 		    ksglen -= usglen;
                     break;
 		}
 		else {
 		    if (ksglen >= num_xfer) {
-			if (ok) __copy_from_user(p, up, num_xfer);
+			if (ok) 
+			    if (__copy_from_user(p, up, num_xfer)) 
+			        return -EFAULT;
 			return 0;
 		    }
-		    if (ok) __copy_from_user(p, up, ksglen);
+		    if (ok) 
+		        if (__copy_from_user(p, up, ksglen)) 
+			    return -EFAULT;
 		    up += ksglen;
 		    usglen -= ksglen;
 		}
@@ -1964,9 +1992,10 @@
 	    count = num_xfer;
     }
     else {
-	__copy_from_user(&u_iovec,
-			 (unsigned char *)hp->dxferp + (ind * SZ_SG_IOVEC),
-			 SZ_SG_IOVEC);
+	if (__copy_from_user(&u_iovec,
+			     (unsigned char *)hp->dxferp + (ind * SZ_SG_IOVEC),
+			     SZ_SG_IOVEC)) 
+	    return -EFAULT;
 	p = (unsigned char *)u_iovec.iov_base;
 	count = (int)u_iovec.iov_len;
     }
@@ -2050,7 +2079,8 @@
 		res = sg_u_iovec(hp, iovec_count, j, 0, &usglen, &up);
 		if (res) return res;
 		usglen = (num_xfer > usglen) ? usglen : num_xfer;
-		__copy_to_user(up, p, usglen);
+		if (__copy_to_user(up, p, usglen)) 
+		    return -EFAULT;
 		p += usglen;
 		num_xfer -= usglen;
 		if (num_xfer <= 0)
@@ -2078,20 +2108,28 @@
 		    break;
 		if (ksglen > usglen) {
 		    if (usglen >= num_xfer) {
-			if (ok) __copy_to_user(up, p, num_xfer);
+			if (ok) 
+			    if (__copy_to_user(up, p, num_xfer)) 
+			        return -EFAULT;
 			return 0;
 		    }
-		    if (ok) __copy_to_user(up, p, usglen);
+		    if (ok) 
+		        if (__copy_to_user(up, p, usglen)) 
+			    return -EFAULT;
 		    p += usglen;
 		    ksglen -= usglen;
 		    break;
 		}
 		else {
 		    if (ksglen >= num_xfer) {
-			if (ok) __copy_to_user(up, p, num_xfer);
+			if (ok) 
+			    if (__copy_to_user(up, p, num_xfer)) 
+			        return -EFAULT;
 			return 0;
 		    }
-		    if (ok) __copy_to_user(up, p, ksglen);
+		    if (ok) 
+		        if (__copy_to_user(up, p, ksglen)) 
+			    return -EFAULT;
 		    up += ksglen;
 		    usglen -= ksglen;
 		}
@@ -2101,14 +2139,14 @@
     return 0;
 }
 
-static void sg_read_oxfer(Sg_request * srp, char * outp, int num_read_xfer)
+static int sg_read_oxfer(Sg_request * srp, char * outp, int num_read_xfer)
 {
     Sg_scatter_hold * schp = &srp->data;
 
     SCSI_LOG_TIMEOUT(4, printk("sg_read_oxfer: num_read_xfer=%dn",
 			       num_read_xfer));
     if ((! outp) || (num_read_xfer <= 0))
-        return;
+        return 0;
     if(schp->k_use_sg > 0) {
         int k, num;
         struct scatterlist * sclp = (struct scatterlist *)schp->buffer;
@@ -2116,11 +2154,13 @@
 	for (k = 0; (k < schp->k_use_sg) && sg_scatg2virt(sclp); ++k, ++sclp) {
             num = (int)sclp->length;
             if (num > num_read_xfer) {
-                __copy_to_user(outp, sg_scatg2virt(sclp), num_read_xfer);
+                if (__copy_to_user(outp, sg_scatg2virt(sclp), num_read_xfer))
+                    return -EFAULT;
                 break;
             }
             else {
-                __copy_to_user(outp, sg_scatg2virt(sclp), num);
+                if (__copy_to_user(outp, sg_scatg2virt(sclp), num))
+                    return -EFAULT;
                 num_read_xfer -= num;
                 if (num_read_xfer <= 0)
                     break;
@@ -2129,7 +2169,9 @@
         }
     }
     else
-        __copy_to_user(outp, schp->buffer, num_read_xfer);
+        if (__copy_to_user(outp, schp->buffer, num_read_xfer))
+	    return -EFAULT;
+    return 0;
 }
 
 static void sg_build_reserve(Sg_fd * sfp, int req_size)
@@ -2820,7 +2862,9 @@
     if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 	return -EACCES;
     num = (count < 10) ? count : 10;
-    copy_from_user(buff, buffer, num);
+    if (copy_from_user(buff, buffer, num)) {
+	return -EFAULT;
+    }
     buff[num] = '0';
     sg_allow_dio = simple_strtoul(buff, 0, 10) ? 1 : 0;
     return count;
@@ -2847,7 +2891,8 @@
     if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 	return -EACCES;
     num = (count < 10) ? count : 10;
-    copy_from_user(buff, buffer, num);
+    if (copy_from_user(buff, buffer, num))
+        return -EFAULT;
     buff[num] = '0';
     k = simple_strtoul(buff, 0, 10);
     if (k <= 1048576) {
-- 
  Don't blame me: the Monkey is driving
